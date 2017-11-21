//
//  MovieInfoViewController.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-17.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class MovieInfoViewController: UIViewController {
    
    @IBOutlet var outerView: UIView!
    @IBOutlet weak var uiView: UIView!
    
    @IBOutlet weak var image_poster: UIImageView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_releaseDate: UILabel!
    @IBOutlet weak var label_genres: UILabel!
    @IBOutlet weak var label_budget: UILabel!
    @IBOutlet weak var label_revenue: UILabel!
    @IBOutlet weak var label_homepage: UILabel!
    @IBOutlet weak var label_tagline: UILabel!
    @IBOutlet weak var label_overview: UILabel!
    
    var selectedMovie: JSON?
    var selectedMoviePoster: UIImage?
    var selectedMovieTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Movie Info"
        self.outerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.uiView.isHidden = true
        KRProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            KRProgressHUD.dismiss()
            self.uiView.isHidden = false
            
            self.uiView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
            
            if let poster = self.selectedMoviePoster {
                let img = self.image_poster
                img?.image = poster
                img?.layer.shadowColor = UIColor.black.cgColor
                img?.layer.shadowOpacity = 1
                img?.layer.shadowOffset = CGSize.zero
                img?.layer.shadowRadius = 10
                img?.layer.shadowPath = UIBezierPath(roundedRect:  self.image_poster.bounds, cornerRadius: 10).cgPath
            }
            
            if let movie = self.selectedMovie {
                let movieId = movie["id"].stringValue
                let url = "\(ApiConstants.baseUrl)/movie/\(movieId)?api_key=\(ApiConstants.API_KEY)&language=en-US"
                self.setPrimaryMovieInfo(url: url)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPrimaryMovieInfo(url: String) {
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    for (key,subJson):(String, JSON) in json {
                        if key == "title" {
                            self.label_title.text = subJson.stringValue
                            self.selectedMovieTitle = subJson.stringValue
                        } else if key == "release_date" {
                            self.label_releaseDate.text = "Release Date: \(subJson.stringValue)"
                        } else if key == "genres" {
                            self.label_genres.text = "Genres: "
                            for i in 0...subJson.count - 1 {
                                if i != subJson.count - 1 {
                                    self.label_genres.text! += " \(subJson[i]["name"].stringValue),"
                                } else {
                                    self.label_genres.text! += " \(subJson[i]["name"].stringValue)"
                                }
                            }
                        } else if key == "budget" {
                            if subJson.stringValue == "" || subJson.stringValue == "0" {
                                self.label_budget.text = "Budget: n/a"
                            } else {
                                self.label_budget.text = "Budget: \(subJson.stringValue)"
                            }
                        } else if key == "revenue" {
                            if subJson.stringValue == "" || subJson.stringValue == "0" {
                                self.label_revenue.text = "Revenue: n/a"
                            } else {
                                self.label_revenue.text = "Revenue: \(subJson.stringValue)"
                            }
                        } else if key == "homepage" {
                            if subJson.stringValue == "" {
                                self.label_homepage.text = "Homepage: n/a"
                            } else {
                                self.label_homepage.text = "Homepage:\n\(subJson.stringValue)"
                            }
                        } else if key == "tagline" {
                            if subJson.stringValue == "" {
                                self.label_tagline.text = "Tagline: n/a"
                            } else {
                                self.label_tagline.text = "Tagline:\n\(subJson.stringValue)"
                            }
                        } else if key == "overview" {
                            self.label_overview.text = "Overview:\n\n" + subJson.stringValue
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    @IBAction func goToReviewPage(_ sender: Any) {
        let vc = ReviewViewController()
        vc.movie = self.selectedMovie
        vc.poster = self.selectedMoviePoster
        vc.movieTitle = self.selectedMovieTitle
        self.navigationController?.pushViewController(vc, animated: true)
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
