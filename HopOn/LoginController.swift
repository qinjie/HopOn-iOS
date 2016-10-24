//
//  LoginController.swift
//  HopOn
//
//  Created by Intern on 5/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire

class LoginController: UIViewController {

    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtErrorMessage: UILabel!
    @IBOutlet weak var txtLogin: UIButton!
    var Transfer: UserDefaults!
    override func viewDidLoad() {
        super.viewDidLoad()
        Transfer = UserDefaults()
        txtErrorMessage.text = ""
        txtLogin.layer.cornerRadius = 4
        txtLogin.layer.borderWidth = 1
        txtLogin.layer.borderColor = UIColor.white.cgColor
        
    }
    @IBAction func returnKeyUsernameTapped(_ sender: AnyObject) {
        self.txtPassword.becomeFirstResponder()
    }
    @IBAction func returnKeyPasswordTapped(_ sender: AnyObject) {
        self.btnLoginTapped(sender)
    }
    @IBAction func inputPassword(_ sender: AnyObject) {
        txtPassword.isSecureTextEntry = true
    }
    
    @IBAction func inputUsername(_ sender: AnyObject) {
        txtErrorMessage.text = ""
    }
    

    @IBAction func btnLoginTapped(_ sender: AnyObject) {
        //Wating dialog
//        let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: UIAlertControllerStyle.alert)
//        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
//        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
//        spinnerIndicator.color = UIColor.black
//        spinnerIndicator.startAnimating()
//        alertController.view.addSubview(spinnerIndicator)
//        self.present(alertController, animated: false, completion: nil)
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/user/login")
        let headers: HTTPHeaders = ["":""]
        let parameters: Parameters = [
            "username": txtUsername.text!,
            "password": txtPassword.text!
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                if let JSON = response.result.value as? [String: Any] {
                    Constants.token = JSON["token"] as! String
                    Constants.fullname = JSON["fullname"] as! String
                    DispatchQueue.main.async(execute: {
                        //alertController.dismiss(animated: true, completion: nil)
                        OperationQueue.main.addOperation {
                            self.performSegue(withIdentifier: "segueLogin", sender: nil)
                        }
                    })
                }
            }
            else{
                if (statusCode == 400){
                    DispatchQueue.main.async(execute: {
//                        alertController.dismiss(animated: true, completion: nil)
                        self.txtErrorMessage.text = "Incorrect data!"
                    })
                }
                else{
                    DispatchQueue.main.async(execute: {
//                        alertController.dismiss(animated: true, completion: nil)
                        self.txtErrorMessage.text = "Server error!"
                    })
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
