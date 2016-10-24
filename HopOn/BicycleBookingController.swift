//
//  BicycleBookingController.swift
//  HopOn
//
//  Created by Intern on 16/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire

class BicycleBookingController: UIViewController {

    @IBOutlet weak var txtStationName: UILabel!
    @IBOutlet weak var txtStationAddress: UILabel!
    @IBOutlet weak var txtNumber: UILabel!
    @IBOutlet weak var txtBrandModel: UILabel!
    @IBOutlet weak var txtBack: UIButton!
    @IBOutlet weak var txtNext: UIButton!
    @IBOutlet weak var txtBook: UIButton!
    @IBOutlet weak var txtAlert: UILabel!
    
    var bicycleArray = [Bicycle]()
    var Transfer: UserDefaults!
    var number: Int = 0
    var station_name: String = ""
    var station_address: String = ""
    var station_id: String = ""
    var total: Int = 0
    var totalTxt: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtBook.layer.cornerRadius = 4
        txtBook.layer.borderWidth = 1
        txtBook.layer.borderColor = UIColor.white.cgColor
        txtBack.isEnabled = false
        txtNext.isEnabled = false
        txtBook.isEnabled = false
        txtAlert.text = "No bicycle is available"
        Transfer = UserDefaults()
        txtStationName.text = station_name
        txtStationAddress.text = station_address
        loadData()
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        if (number == 1){
            txtBack.isEnabled = false
        }
        txtNext.isEnabled = true
        number -= 1
        txtNumber.text = (String)(number + 1) + "/" + totalTxt
        txtBrandModel.text = bicycleArray[number].brand + "/" + bicycleArray[number].model
    }
    @IBAction func btnNextTapped(_ sender: AnyObject) {
        if (number == bicycleArray.count - 2){
            txtNext.isEnabled = false
        }
        txtBack.isEnabled = true
        number += 1
        txtNumber.text = (String)(number + 1) + "/" + totalTxt
        txtBrandModel.text = bicycleArray[number].brand + "/" + bicycleArray[number].model
    }
    @IBAction func btnBookTapped(_ sender: AnyObject) {
        if (self.bicycleArray.count > 0){
            let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/bicycle/book")
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Constants.token,
                "Accept": "application/json"
            ]
            let parameters: Parameters = [
                "stationId" : self.station_id,
                "bicycleTypeId" : self.bicycleArray[number].bicycle_type_id!
            ]
            Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
                let statusCode = response.response?.statusCode
                if (statusCode == 200){
                    let secondTab = self.tabBarController?.viewControllers![2] as! BookingNavigationController
                    secondTab.loadData()
                    DispatchQueue.main.async(execute: {
                        self.tabBarController!.selectedIndex = 2
                    })
                }
                else{
                    DispatchQueue.main.async(execute: {
                        self.txtAlert.text = "Server error!"
                    })
                }
            }
        }
    }
    func loadData(){
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/station/detail?stationId=" + self.station_id)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constants.token,
            "Accept": "application/json"
        ]
        
        Alamofire.request(url!, headers: headers).responseString { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                let bicycles = [Bicycle](json: response.result.value)
                self.bicycleArray = bicycles
                DispatchQueue.main.async(execute: {
                    if (self.bicycleArray.count > 0){
                        self.txtBook.isEnabled = true
                        self.total = self.bicycleArray.count
                        self.totalTxt = (String)(self.bicycleArray.count)
                        self.txtNumber.text = (String)(self.number + 1) + "/" + self.totalTxt
                        self.txtBrandModel.text = self.bicycleArray[self.number].brand + self.bicycleArray[self.number].model
                        self.txtAlert.text = ""
                        if (self.bicycleArray.count > 1){
                            self.txtNext.isEnabled = true
                        }
                    }
                })
            }
        }
    }
}
