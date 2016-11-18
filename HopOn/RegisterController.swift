//
//  RegisterController.swift
//  HopOn
//
//  Created by Intern on 5/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire

class RegisterController: UIViewController {

    @IBOutlet weak var txtErrorMessage: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    var Transfer: UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Transfer = UserDefaults()
        txtErrorMessage.text = ""
        //txtName.layer.cornerRadius = 20.0
        //txtName.layer.borderWidth = 1.0
        //txtPassword.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.35)
        btnContinue.layer.cornerRadius = 5.0
    }
    
    @IBAction func btnContinueTapped(_ sender: AnyObject) {
        if (txtName.text == "" || txtEmail.text == "" || txtMobile.text == "" || txtPassword.text == ""){
            txtErrorMessage.text = "Please insert all feild before Continue"
        }
        else{
            txtErrorMessage.text = ""
            let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/user/signup")
            let headers: HTTPHeaders = ["":""]
            let parameters: Parameters = [
                "fullname" : self.txtName.text!,
                "email" : self.txtEmail.text!,
                "mobile" : self.txtMobile.text!,
                "password" : self.txtPassword.text!
            ]
            
            Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                let statusCode = response.response?.statusCode
                if (statusCode == 200){
                    DispatchQueue.main.async(execute: {
                        OperationQueue.main.addOperation {
                            self.performSegue(withIdentifier: "segueRegister", sender: nil)
                        }
                    })
                }
                else{
                    if (statusCode == 400){
                        if let JSON = response.result.value as? [String: Any] {
                            let code = JSON["code"] as? Int
                            var Err: String = ""
                            if (code == 8){
                                Err = "Invalid password"
                            }
                            if (code == 10){
                                Err = "Invalid email"
                            }
                            if (code == 11){
                                Err = "Invalid phone"
                            }
                            if (code == 12){
                                Err = "Invalid full name"
                            }
                            DispatchQueue.main.async(execute: {
                                self.txtErrorMessage.text = Err
                            })
                        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.Transfer.set(self.txtEmail.text, forKey: "signUpEmail")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
    
