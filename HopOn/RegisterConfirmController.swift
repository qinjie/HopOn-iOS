//
//  RegisterConfirmController.swift
//  HopOn
//
//  Created by Intern on 8/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire

class RegisterConfirmController: UIViewController {

    @IBOutlet weak var txtCode: UILabel!
    @IBOutlet weak var txtErrorMessage: UILabel!
    @IBOutlet weak var txtActiveCode: UITextField!
    @IBOutlet weak var txtResent: UIButton!
    @IBOutlet weak var txtSignUp: UIButton!
    var email:String = ""
    var Transfer: UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Transfer = UserDefaults()
        email = Transfer.object(forKey: "signUpEmail") as! String
        txtErrorMessage.text = ""
        txtCode.text = "A code has been sent to your email address " + email
        txtCode.lineBreakMode = NSLineBreakMode.byWordWrapping
        txtCode.numberOfLines = 3
        txtResent.layer.cornerRadius = 5.0
        txtSignUp.layer.cornerRadius = 5.0
    }
    
    @IBAction func btnResentTapped(_ sender: AnyObject) {
        txtErrorMessage.text = ""
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/user/resend-email")
        let headers: HTTPHeaders = ["":""]
        let parameters: Parameters = [
            "email" : self.email
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "", message:
                        "Re-sent successfully", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                })
            }
            else{
                DispatchQueue.main.async(execute: {
                    self.txtErrorMessage.text = "Server error!"
                })
            }
        }
    }
    
    @IBAction func btnSignuptapped(_ sender: AnyObject) {
        if (self.txtActiveCode.text == ""){
            self.txtErrorMessage.text = "Please enter your active code"
        }
        else{
            txtErrorMessage.text = ""
            let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/user/activate")
            let headers: HTTPHeaders = ["":""]
            let parameters: Parameters = [
                "email" : self.email,
                "token" : self.txtActiveCode.text!
            ]
            
            Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                let statusCode = response.response?.statusCode
                if (statusCode == 200){
                    if let JSON = response.result.value as? [String: Any] {
                        Constants.token = JSON["token"] as! String
                        Constants.fullname = JSON["fullname"] as! String
                        OperationQueue.main.addOperation {
                            self.performSegue(withIdentifier: "segueRegisterSuccess", sender: nil)
                        }
                    }
                    OperationQueue.main.addOperation {
                        self.performSegue(withIdentifier: "segueRegisterSuccess", sender: nil)
                    }
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
