//
//  FeedbackController.swift
//  HopOn
//
//  Created by Intern on 19/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire

class FeedbackController: UIViewController {

    @IBOutlet weak var txtBookingId: UILabel!
    @IBOutlet weak var btnOption1: CheckBox!
    @IBOutlet weak var btnOption2: CheckBox!
    @IBOutlet weak var btnOption3: CheckBox!
    @IBOutlet weak var btnOption4: CheckBox!
    @IBOutlet weak var btnOption5: CheckBox!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewStarRate: RatingControl!
    @IBOutlet weak var txtComment: UITextField!
    var Transfer: UserDefaults!
    override func viewDidLoad() {
        super.viewDidLoad()
        Transfer = UserDefaults()
        let booking_id:String = Transfer.object(forKey: "fb_bookingId") as! String
        txtBookingId.text = booking_id
        btnSubmit.layer.cornerRadius = 4
        btnSubmit.layer.borderWidth = 1
        btnSubmit.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func btnSubmitTapped(_ sender: AnyObject) {
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/feedback/new")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constants.token,
            "Accept": "application/json"
        ]
        var feedbackList = [Int]()
        if (btnOption1.isChecked){ feedbackList.append(1) }
        if (btnOption2.isChecked){ feedbackList.append(2) }
        if (btnOption3.isChecked){ feedbackList.append(3) }
        if (btnOption4.isChecked){ feedbackList.append(4) }
        if (btnOption5.isChecked){ feedbackList.append(5) }
        let rating: String = (String)(self.viewStarRate.rating)
        let parameters: Parameters = [
            "rentalId" : self.txtBookingId.text,
            "listIssue" : feedbackList,
            "comment" : self.txtComment.text,
            "rating" : rating
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                OperationQueue.main.addOperation {
                    DispatchQueue.main.async(execute: {
                        let alertController = UIAlertController(title: "", message:
                            "Thanks for your feedback", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        {action -> Void in
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                        self.present(alertController, animated: true, completion: nil)
                    })
                    
                }

            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
