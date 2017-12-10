//
//  ResetPasswordViewController.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-09.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField_email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.textField_email.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleNetworkConnection(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitResetPassword(_ sender: Any) {
        if self.textField_email.text == "" {
            genericAlert(alertTitle: "Oops!", alertMessage: "Please enter an email.", vc: self)
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.textField_email.text!, completion: { (error) in
                var title = ""
                var message = ""
                if error != nil {
                    title = "Oops!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.textField_email.text = ""
                }
                genericAlert(alertTitle: title, alertMessage: message, vc: self)
            })
        }
    }
    
    // hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
