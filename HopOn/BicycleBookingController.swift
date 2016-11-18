//
//  BicycleBookingController.swift
//  HopOn
//
//  Created by Intern on 16/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BicycleBookingController: UIViewController {

    @IBOutlet weak var txtStationName: UILabel!
    @IBOutlet weak var txtStationAddress: UILabel!
    @IBOutlet weak var txtNumber: UILabel!
    @IBOutlet weak var txtBrandModel: UILabel!
    @IBOutlet weak var txtBack: UIButton!
    @IBOutlet weak var txtNext: UIButton!
    @IBOutlet weak var txtBook: UIButton!
    @IBOutlet weak var txtAlert: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    
    var bicycleArray = [Bicycle]()
    var Transfer: UserDefaults!
    var number: Int = 0
    var station_name: String = ""
    var station_address: String = ""
    var station_id: String = ""
    var total: Int = 0
    var totalTxt: String = ""
    var alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: UIAlertControllerStyle.alert)
    override func viewDidLoad() {
        super.viewDidLoad()
        //Wating dialog
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)

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
        let url1 = URL(string: bicycleArray[number].listImageUrl[0])
        let url2 = URL(string: bicycleArray[number].listImageUrl[1])
        self.downloadImage(url: url1!, view: self.img1)
        self.downloadImage(url: url2!, view: self.img2)
    }
    @IBAction func btnNextTapped(_ sender: AnyObject) {
        if (number == bicycleArray.count - 2){
            txtNext.isEnabled = false
        }
        txtBack.isEnabled = true
        number += 1
        txtNumber.text = (String)(number + 1) + "/" + totalTxt
        txtBrandModel.text = bicycleArray[number].brand + "/" + bicycleArray[number].model
        let url1 = URL(string: bicycleArray[number].listImageUrl[0])
        let url2 = URL(string: bicycleArray[number].listImageUrl[1])
        self.downloadImage(url: url1!, view: self.img1)
        self.downloadImage(url: url2!, view: self.img2)
    }
    @IBAction func btnBookTapped(_ sender: AnyObject) {
        //Wating dialog
        alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
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
                    secondTab.disconnectBean()
                    secondTab.loadData()
                    DispatchQueue.main.async(execute: {
                        let secondTab = self.tabBarController?.viewControllers![1] as! StationListNavigationController
                        secondTab.afterBook()
                        self.alertController.dismiss(animated: true, completion: nil)
                        self.tabBarController!.selectedIndex = 2
                    })
                }
                else{
                    DispatchQueue.main.async(execute: {
                        self.alertController.dismiss(animated: true, completion: nil)
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
                        let url1 = URL(string: self.bicycleArray[self.number].listImageUrl[0])
                        let url2 = URL(string: self.bicycleArray[self.number].listImageUrl[1])
                        self.downloadImage(url: url1!, view: self.img1)
                        self.downloadImage(url: url2!, view: self.img2)
                        self.alertController.dismiss(animated: true, completion: nil)
                    }
                    else{
                        DispatchQueue.main.async(execute: {
                            self.alertController.dismiss(animated: true, completion: nil)
                        })
                    }
                })
            }
        }
    }
    func downloadImage(url: URL, view: UIImageView) {
        Alamofire.request(url, method: .get).responseData { response in
            debugPrint(response)
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let data = response.result.value {
                DispatchQueue.main.async() { () -> Void in
                    view.image = UIImage(data: data)
                }
            }
        }
    }
}
