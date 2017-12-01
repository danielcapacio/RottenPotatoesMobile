//
//  ReviewsViewController.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-24.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit
import FirebaseDatabase
import KRProgressHUD
import SwiftyJSON

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var ref = Database.database().reference()
    var handle: DatabaseHandle?
    var allReviews:[Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        KRProgressHUD.show(withMessage: "Loading reviews...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            KRProgressHUD.dismiss()
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            let nibName = UINib(nibName: "ReviewsTableViewCell", bundle: nil)
            self.tableView.register(nibName, forCellReuseIdentifier: "reviewsTableViewCell")
            self.tableView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
            
            let reviewsReference = self.ref.child("users").child("\(UserInfo.username)").child("reviews").queryOrderedByKey()
            reviewsReference.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    //    // snapshot in weird, random order - don't want that
                    //    let reviews = snapshot.value as! [String: AnyObject]
                    //    for (_, review) in reviews
                    //    {
                    //        let reviewObj = Review()
                    //        reviewObj.date      = review["date"]        as? String
                    //        reviewObj.username  = review["username"]    as? String
                    //        reviewObj.movie     = review["movie"]       as? String
                    //        reviewObj.comment   = review["comment"]     as? String
                    //        reviewObj.rating    = review["rating"]      as? String
                    //        self.allReviews.append(reviewObj)
                    //    }
                    for child in snapshot.children {
                        let child = child as! DataSnapshot
                        if let reviews = child.value as? [String: AnyObject] {
                            let reviewObj = Review()
                            for review in reviews {
                                if review.key == "date" {
                                    reviewObj.date = review.value as! String
                                } else if review.key == "username" {
                                    reviewObj.username = review.value as! String
                                } else if review.key == "movie" {
                                    reviewObj.movie = review.value as! String
                                } else if review.key == "comment" {
                                    reviewObj.comment = review.value as! String
                                } else if review.key == "rating" {
                                    reviewObj.rating = review.value as! String
                                    self.allReviews.append(reviewObj)
                                }
                            }
                        }
                    }
                    self.allReviews.reverse()
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
        let review = self.allReviews[indexPath.row]
        cell.label_date.text        = review.date
        cell.label_username.text    = review.username
        cell.label_movieTitle.text  = review.movie
        cell.label_comment.text     = review.comment
        cell.label_rating.text      = review.rating
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
