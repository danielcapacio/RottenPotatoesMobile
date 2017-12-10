//
//  TopRatedViewController.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-16.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import KRProgressHUD

class TopRatedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var topRatedMovies: [JSON] = []
    var imgCache: [String : UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Top Rated"
        let url = "\(ApiHelper.baseUrl)\(ApiHelper.topRated)?api_key=\(ApiHelper.API_KEY)&language=en-US&region=US"
        
        KRProgressHUD.show(withMessage: "Loading movies...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            let nibName = UINib(nibName: "TopRatedTableViewCell", bundle: nil)
            self.tableView.register(nibName, forCellReuseIdentifier: "topRatedTableViewCell")
            
            self.loadTopRatedMovies(url: url)
            // self.tableView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0) // light gray
            self.tableView.backgroundColor = UIColor(red:0.95, green:0.97, blue:0.91, alpha:1.0)
            KRProgressHUD.dismiss()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleNetworkConnection(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows: Int
        // set max number of table to be 40, else number of movie results
        if (ApiHelper.MAX_TABLE_ROWS <= topRatedMovies.count) {
            numberOfRows = ApiHelper.MAX_TABLE_ROWS
        } else {
            numberOfRows = topRatedMovies.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topRatedTableViewCell", for: indexPath) as! TopRatedTableViewCell
        if topRatedMovies.count > 0 {
            // getting individual movie
            let movie = topRatedMovies[indexPath.row]
            
            // poster image
            let imagePath = movie["poster_path"].stringValue
            let movieId = movie["id"].stringValue
            let posterId = movieId + "_" + ApiHelper.imageSize.medium.rawValue
            
            if let posterImage = imgCache[posterId] {
                cell.image_poster.image = posterImage
            } else {
                let url = ApiHelper.baseUrlImage + ApiHelper.imageSize.medium.rawValue + imagePath
                Alamofire.request(url).responseImage { response in
                    switch response.result {
                    case .success(let value):
                        let image = value
                        self.imgCache[posterId] = image
                        DispatchQueue.main.async(execute: {
                            cell.image_poster.image = image
                        })
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            // store backdrop in image cache to be sent to movie info controller at func tableView(... didSelectRowAt
            let backdropPath = movie["backdrop_path"].stringValue
            let backdropId = movieId + "_" + ApiHelper.imageSize.big.rawValue
            let backdropUrl = ApiHelper.baseUrlImage + ApiHelper.imageSize.big.rawValue + backdropPath
            Alamofire.request(backdropUrl).responseImage { response in
                switch response.result {
                case .success(let value):
                    let image = value
                    self.imgCache[backdropId] = image
                case .failure(let error):
                    print(error)
                }
            }
            
            // title
            if let movieTitle = movie["title"].string {
                cell.label_title.text = movieTitle
            } else {
                cell.label_title.text = "Error loading title"
            }
            
            // year
            let releaseDate = movie["release_date"].string
            if let date = releaseDate {
                let year = String(Array(date)[0...3])
                cell.label_year.text = "(" + year + ")"
            } else {
                cell.label_year.text = "Error loading year"
            }
            
            // vote average
            if let voteAverage = movie["vote_average"].double {
                cell.label_voteAverage.text = "Vote Average: " + String(format:"%.1f", voteAverage)
            } else {
                cell.label_voteAverage.text = "Error loading vote average"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieInfoViewController()
        
        let movie = topRatedMovies[indexPath.row]
        vc.selectedMovie = movie
        
        let backdropId = movie["id"].stringValue + "_" + ApiHelper.imageSize.big.rawValue
        let backdropImage = imgCache[backdropId]
        vc.selectedMovieBackdrop = backdropImage
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /**
     * Load into table, movie results with a maximum of 40 movies - 20 per api request page.
     */
    func loadTopRatedMovies(url: String) {
        var moviesListPage1: [JSON] = []
        var moviesListPage2: [JSON] = []
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var moreThanOnePage = false
                // check if total_pages is greater than 1
                for (key, subJson):(String, JSON) in json {
                    if key == "total_pages" {
                        // more than 1 page result
                        if subJson > 1 {
                            moreThanOnePage = true
                        }
                    }
                }
                for (key, subJson):(String, JSON) in json {
                    if key == "results" {
                        moviesListPage1.append(subJson)
                    }
                }
                for movie in moviesListPage1 {
                    // iterate through the page 1 results and add to global json variable
                    for i in 0...(moviesListPage1[0].count - 1) {
                        self.topRatedMovies.append(movie[i])
                    }
                }
                // send another request if there is more than one page result
                if moreThanOnePage {
                    Alamofire.request(url + "&page=2").validate().responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            for (key, subJson):(String, JSON) in json {
                                if key == "results" {
                                    moviesListPage2.append(subJson)
                                }
                            }
                            for movie in moviesListPage2 {
                                // iterate through the page 2 results and add to global json variable
                                for i in 0...(moviesListPage2[0].count - 1) {
                                    self.topRatedMovies.append(movie[i])
                                }
                            }
                            self.tableView.reloadData()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
