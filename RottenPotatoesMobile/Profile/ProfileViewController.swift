//
//  ProfileViewController.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-15.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var image_profileIcon: UIImageView!
    @IBOutlet weak var label_username: UILabel!
    @IBOutlet weak var label_firstname: UILabel!
    @IBOutlet weak var label_lastname: UILabel!
    @IBOutlet weak var label_email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Profile"
        self.image_profileIcon.image = #imageLiteral(resourceName: "parrot")
        self.label_username.text = UserInfo.username
        self.label_firstname.text = UserInfo.firstName
        self.label_lastname.text = UserInfo.lastName
        self.label_email.text = UserInfo.email
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleNetworkConnection(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
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
