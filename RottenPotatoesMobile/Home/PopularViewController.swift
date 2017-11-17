//
//  PopularViewController.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-16.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class PopularViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var popularMovies: [JSON] = []
    var imgCache: [String : UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Popular"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "PopularTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "popularTableViewCell")
        
        let url = "\(ApiConstants.baseUrl)\(ApiConstants.discover)?api_key=\(ApiConstants.API_KEY)&sort_by=popularity.desc"
        self.loadPopularMovies(url: url)
        
        tableView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
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
        if (ApiConstants.MAX_TABLE_ROWS <= popularMovies.count) {
            numberOfRows = ApiConstants.MAX_TABLE_ROWS
        } else {
            numberOfRows = popularMovies.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularTableViewCell", for: indexPath) as! PopularTableViewCell
        if popularMovies.count > 0 {
            // getting individual movie
            let movie = popularMovies[indexPath.row]
            
            // poster image
            let imagePath = movie["poster_path"].stringValue
            let movieId = movie["id"].stringValue
            let posterId = movieId + "_" + ApiConstants.posterSize.medium.rawValue
            
            if let posterImage = imgCache[posterId] {
                cell.image_popularPoster.image = posterImage
            } else {
                let url = ApiConstants.baseUrlPoster + ApiConstants.posterSize.medium.rawValue + imagePath
                Alamofire.request(url).responseImage { response in
                    switch response.result {
                    case .success(let value):
                        let image = value
                        self.imgCache[posterId] = image
                        DispatchQueue.main.async(execute: {
                            cell.image_popularPoster.image = image
                        })
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            // title
            if let movieTitle = movie["title"].string {
                cell.label_popularTitle.text = movieTitle
            } else {
                cell.label_popularTitle.text = "Error loading title"
            }
            
            // year
            let releaseDate = movie["release_date"].string
            if let date = releaseDate {
                let year = String(Array(date)[0...3])
                cell.label_popularYear.text = "(" + year + ")"
            } else {
                cell.label_popularYear.text = "Error loading year"
            }
            
            // popularity rating
            if let popularity = movie["popularity"].double {
                cell.label_popularPopularity.text = "Pop. rating: " + String(format:"%f", popularity)
            } else {
                cell.label_popularPopularity.text = "Error loading popularity"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    /**
     * Load into table, popular movie results with a maximum of 40 movies - 20 per api request page.
     */
    func loadPopularMovies(url: String) {
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
                            self.popularMovies.append(movie[i])
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
                                            self.popularMovies.append(movie[i])
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
