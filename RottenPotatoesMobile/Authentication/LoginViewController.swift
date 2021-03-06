//
//  LoginViewController.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-09.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField_email: UITextField!
    @IBOutlet weak var textField_password: UITextField!
    @IBOutlet weak var image_logo: UIImageView!
    @IBOutlet weak var label_title: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        
        self.textField_email.delegate = self
        self.textField_password.delegate = self
        self.image_logo.image = #imageLiteral(resourceName: "logo-no-bg")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleNetworkConnection(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any) {
        if self.textField_email.text == "" || self.textField_password.text == "" {
            genericAlert(alertTitle: "Required Fields", alertMessage: "Please enter an email and a password.", vc: self)
        } else {
            Auth.auth().signIn(withEmail: self.textField_email.text!, password: self.textField_password.text!) { (user, error) in
                if error == nil {
                    print("You have successfully logged in")
                    
                    self.setUserInfo() { userInformation in
                        UserInfo.firstName = userInformation[0]
                        UserInfo.lastName = userInformation[1]
                        UserInfo.username = userInformation[2]
                        UserInfo.email = self.textField_email.text!
                        UserInfo.password = self.textField_password.text!
                        
                        //Go to the HomeViewController if the login is sucessful
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                        self.present(vc!, animated: true, completion: nil)
                    }
                } else {
                    // Tells the user that there is an error and then gets firebase to tell them the error
                    genericAlert(alertTitle: "Oops!", alertMessage: (error?.localizedDescription)!, vc: self)
                }
            }
        }
    }
    
    /**
     * Set global user info variables (firstName, lastName, username) within completion block.
     */
    func setUserInfo(completion: @escaping ([String])->()) {
        // locating user's additional info in db, based on login email
        var userFound = false
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                for user in users.children.allObjects as! [DataSnapshot] {
                    if (user.key == "email") {
                        if (user.value as? String == self.textField_email.text) {
                            userFound = true
                        }
                    }
                    if (userFound && user.key == "firstName") {
                        UserInfo.firstName = user.value as! String
                    }
                    if (userFound && user.key == "lastName") {
                        UserInfo.lastName = user.value as! String
                    }
                }
                if userFound {
                    UserInfo.username = users.key
                    userFound = false
                }
            }
            let userInformation = [UserInfo.firstName,
                                   UserInfo.lastName,
                                   UserInfo.username]
            completion(userInformation)
        });
    }
    
    // hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField_email {
            textField_password.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
}

