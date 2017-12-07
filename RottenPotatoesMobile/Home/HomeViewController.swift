//
//  HomeViewController.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-10.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let titleData = ["Popular",
                    "Now Playing",
                    "Top Rated",
                    "Upcoming"]
    
    let subTitleData = ["List of the current popular movies.",
                        "List of movies in theatres.",
                        "Top rated movies on TMDb.",
                        "List of upcoming movies in theatres."]
    
    let imageData = ["video-camera",
                     "tickets",
                     "frame",
                     "director-chair"]
    
    let categoryData = [PopularViewController(),
                        NowPlayingViewController(),
                        TopRatedViewController(),
                        UpcomingViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Welcome \(UserInfo.firstName)"
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibName = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "homeTableViewCell")
        
        // tableView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0) // light gray
        self.tableView.backgroundColor = UIColor(red:0.95, green:0.97, blue:0.91, alpha:1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.commonInit(imageData[indexPath.item], title: titleData[indexPath.item], sub: subTitleData[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = categoryData[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
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
