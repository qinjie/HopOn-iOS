//
//  ResetPasswordController.swift
//  HopOn
//
//  Created by Intern on 5/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire

class ResetPasswordController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtErrorMessage: UILabel!
    @IBOutlet weak var txtSubmit: UIButton!
    var Transfer: UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Transfer = UserDefaults()
        txtErrorMessage.text = ""
        txtSubmit.layer.cornerRadius = 5.0
    }
    @IBAction func btnSubmitTapped(_ sender: AnyObject) {
        if (txtEmail.text == ""){
            txtErrorMessage.text = "Please insert your email address!"
        }
        else{
            txtErrorMessage.text = ""
            let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/user/reset-password")
            let headers: HTTPHeaders = ["":""]
            let parameters: Parameters = [
                "email_mobile" : self.txtEmail.text!
            ]
            
            Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                let statusCode = response.response?.statusCode
                if (statusCode == 200){
                    DispatchQueue.main.async(execute: {
                        self.txtErrorMessage.text = "Email sent!\nPlease check your email"
                        self.txtEmail.isEnabled = false
                    })
                }
                else{
                    if (statusCode == 400){
                        DispatchQueue.main.async(execute: {
                            self.txtErrorMessage.text = "Incorrect data!"
                        })
                    }
                    else{
                        DispatchQueue.main.async(execute: {
                            self.txtErrorMessage.text = "Server error!"
                        })
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
