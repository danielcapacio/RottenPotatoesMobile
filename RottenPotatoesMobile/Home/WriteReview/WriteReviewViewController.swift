//
//  WriteReviewViewController.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-11-20.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FirebaseDatabase
import KRProgressHUD

class WriteReviewViewController: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var outerView: UIView!
    @IBOutlet weak var uiView: UIView!
    
    @IBOutlet weak var image_backdrop: UIImageView!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var textView_comment: UITextView!
    @IBOutlet weak var pickerView_rating: UIPickerView!
    @IBOutlet weak var button_save: UIButton!
    
    var movie: JSON?
    var backdrop: UIImage?
    var movieTitle: String?
    
    let ratings = ["1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5",
                   "6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10"]
    
    var selectedRating = "5" // default to 5
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Review"
        self.outerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.uiView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        self.image_backdrop.image = self.backdrop
        self.label_title.text = self.movieTitle
        
        self.textView_comment.delegate = self
        self.textView_comment.text = "Add your comment here..."
        self.textView_comment.textColor = UIColor.lightGray
        
        self.pickerView_rating.dataSource = self
        self.pickerView_rating.delegate = self
        self.pickerView_rating.selectRow(8, inComponent: 0, animated: true) // set default rating to 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveReview(_ sender: Any) {
        if self.textView_comment.text == "" || self.textView_comment.text == "Add your comment here..." {
            let alertController = UIAlertController(title: "Error", message: "Comments field required.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // store user's review into firebase
        ref.child("users").child(UserInfo.username).child("reviews").observeSingleEvent(of: .value, with: { (snapshot) in
            let write = [
                self.label_title.text! as NSString :
                    [
                        "rating" : self.selectedRating as NSString,
                        "comment" : self.textView_comment.text! as NSString
                    ]
            ]
            self.ref.child("users").child(UserInfo.username).child("reviews").updateChildValues(write)
        })
        
        KRProgressHUD.showSuccess(withMessage: "Saved!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            KRProgressHUD.dismiss()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.textView_comment.textColor == UIColor.lightGray {
            self.textView_comment.text = nil
            self.textView_comment.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textView_comment.text.isEmpty {
            self.textView_comment.text = "Add your comment here..."
            self.textView_comment.textColor = UIColor.lightGray
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.ratings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.ratings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRating = ratings[row]
    }
    
    // hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
