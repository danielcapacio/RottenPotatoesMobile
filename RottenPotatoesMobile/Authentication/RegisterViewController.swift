//
//  RegisterViewController.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-09.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField_firstName: UITextField!
    @IBOutlet weak var textField_lastName: UITextField!
    @IBOutlet weak var textField_username: UITextField!
    @IBOutlet weak var textField_email: UITextField!
    @IBOutlet weak var textField_password: UITextField!
    @IBOutlet weak var textField_confirmPassword: UITextField!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.textField_firstName.delegate = self
        self.textField_lastName.delegate = self
        self.textField_username.delegate = self
        self.textField_email.delegate = self
        self.textField_password.delegate = self
        self.textField_confirmPassword.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleNetworkConnection(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: Any) {
        if textField_firstName.text == "" {
            genericAlert(alertTitle: "Required Field", alertMessage: "Please enter a first name.", vc: self)
        } else if textField_lastName.text == "" {
            genericAlert(alertTitle: "Required Field", alertMessage: "Please enter a last name.", vc: self)
        } else if textField_username.text == "" {
            genericAlert(alertTitle: "Required Field", alertMessage: "Please enter a username.", vc: self)
        } else if textField_email.text == "" {
            genericAlert(alertTitle: "Required Field", alertMessage: "Please enter an email.", vc: self)
        } else if textField_password.text != textField_confirmPassword.text {
            genericAlert(alertTitle: "Oops!", alertMessage: "Passwords do not match.", vc: self)
        } else {
            // check if username already exists in the db
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(((self.textField_username.text! as NSString) as String)) {
                    genericAlert(alertTitle: "Oops!", alertMessage: "Username is already being used by another account.", vc: self)
                } else {
                    Auth.auth().createUser(withEmail: self.textField_email.text!, password: self.textField_password.text!) { (user, error) in
                        if error == nil {
                            print("You have successfully signed up")
                            let write = [
                                self.textField_username.text! as NSString :
                                    [
                                        "firstName" : self.textField_firstName.text! as NSString,
                                        "lastName" : self.textField_lastName.text! as NSString,
                                        "email" : self.textField_email.text! as NSString,
                                        "reviews" : nil
                                    ]
                            ]
                            self.ref.child("users").updateChildValues(write)
                            
                            UserInfo.firstName = self.textField_firstName.text!
                            UserInfo.lastName = self.textField_lastName.text!
                            UserInfo.username = self.textField_username.text!
                            UserInfo.email = self.textField_email.text!
                            UserInfo.password = self.textField_password.text!
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                            self.present(vc!, animated: true, completion: nil)
                        } else {
                            genericAlert(alertTitle: "Oops!", alertMessage: (error?.localizedDescription)!, vc: self)
                        }
                    }
                }
            })
        }
    }
    
    // hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // navigate to next field when pressing return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case textField_firstName:
                textField_lastName.becomeFirstResponder()
                break
            case textField_lastName:
                textField_username.becomeFirstResponder()
                break
            case textField_username:
                textField_email.becomeFirstResponder()
                break
            case textField_email:
                textField_password.becomeFirstResponder()
                break
            case textField_password:
                textField_confirmPassword.becomeFirstResponder()
                break
            default:
                textField.resignFirstResponder()
            }
        return true
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
