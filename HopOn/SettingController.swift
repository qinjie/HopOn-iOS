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
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFullName.text = Constants.fullname
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
