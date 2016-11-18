//
//  ChangePasswordController.swift
//  HopOn
//
//  Created by Intern on 8/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordController: UIViewController {

    @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var txtNewPass1: UITextField!
    @IBOutlet weak var txtNewPass2: UITextField!
    @IBOutlet weak var txtErrorMessage: UILabel!
    @IBOutlet weak var txtSubmit: UIButton!
    @IBOutlet weak var viewOldPass: UIView!
    @IBOutlet weak var viewNewPass: UIView!
    var Transfer: UserDefaults!
    override func viewDidLoad() {
        super.viewDidLoad()
        Transfer = UserDefaults()
        txtErrorMessage.text = ""
        txtSubmit.layer.cornerRadius = 4
        txtOldPass.layer.cornerRadius = 4
        viewOldPass.layer.cornerRadius = 4
        viewOldPass.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        viewOldPass.layer.borderWidth = 1
        viewNewPass.layer.cornerRadius = 4
        viewNewPass.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        viewNewPass.layer.borderWidth = 1
        
    }
    @IBAction func btnSubmitTapped(_ sender: AnyObject) {
        if (self.txtNewPass1.text != self.txtNewPass2.text){
            self.txtErrorMessage.text = "Repeat password is not match!"
        }
        else{
            txtErrorMessage.text = ""
            let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/user/change-password")
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Constants.token,
                "Accept": "application/json"
            ]
            let parameters: Parameters = [
                "oldPassword" : self.txtOldPass.text!,
                "newPassword" : self.txtNewPass1.text!
            ]
            
            Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                let statusCode = response.response?.statusCode
                if (statusCode == 200){
                    DispatchQueue.main.async(execute: {
                        let alertController = UIAlertController(title: "", message:
                            "Change password successfully", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                    })

                }
                else{
                    DispatchQueue.main.async(execute: {
                        self.txtErrorMessage.text = "Incorrect data!"
                    })
                }
            }

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
