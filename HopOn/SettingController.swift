//
//  SettingController.swift
//  HopOn
//
//  Created by Intern on 5/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire

class SettingController: UIViewController {
    
    @IBOutlet weak var txtFullName: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtPhone: UILabel!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var txtPassword: UIButton!
    @IBOutlet weak var txtSignOut: UIButton!
    @IBOutlet weak var txtChangeEmail: UIButton!
    @IBOutlet weak var viewControl: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFullName.text = Constants.fullname
        viewInfo.layer.borderWidth = 1
        viewInfo.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        viewControl.layer.borderWidth = 1
        viewControl.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        txtSignOut.layer.borderWidth = 1
        txtSignOut.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        txtChangeEmail.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        txtPassword.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        txtSignOut.layer.cornerRadius = 2
        viewControl.layer.cornerRadius = 2
        viewInfo.layer.cornerRadius = 2
        loadData()
    }
    func loadData(){
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/user/profile")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constants.token,
            "Accept": "application/json"
        ]
        let parameters: Parameters = ["":""]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                if let JSON = response.result.value as? [String: Any] {
                    let email = JSON["email"] as! String
                    let phone = JSON["mobile"] as! String
                    DispatchQueue.main.async(execute: {
                        self.txtEmail.text = email
                        self.txtPhone.text = phone
                    })
                }
            }
        }
    }
    @IBAction func btnSignOut(_ sender: AnyObject) {
        Constants.fullname = ""
        Constants.token = ""
    }
}
