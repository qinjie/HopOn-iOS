//
//  BookingController.swift
//  HopOn
//
//  Created by Intern on 5/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire

class BookingController: UIViewController {

    @IBOutlet weak var btnPickUpStation: UIButton!
    @IBOutlet weak var imgBicycleLeft: UIImageView!
    @IBOutlet weak var imgBicycleRight: UIImageView!
    @IBOutlet weak var txtBookingID: UILabel!
    @IBOutlet weak var txtBrandModel: UILabel!
    @IBOutlet weak var txtBicycleID: UILabel!
    @IBOutlet weak var txtFeature1: UILabel!
    @IBOutlet weak var txtFeature2: UILabel!
    @IBOutlet weak var txtFeature3: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var txtBookedAt: UILabel!
    @IBOutlet weak var txtPickedAt: UILabel!
    @IBOutlet weak var txtPickUpStation: UIButton!
    @IBOutlet weak var txtReturn: UIButton!
    @IBOutlet weak var txtLock: UIButton!
    @IBOutlet weak var viewEmpty: UIView!
    var bicycle_id: String = ""
    var Transfer: UserDefaults!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPickUpStation.isEnabled = false
        self.viewEmpty.isHidden = false
        Transfer = UserDefaults()
        btnPickUpStation.setImage(UIImage(named: "Geo-fence-30.png"), for: UIControlState())
        imgBicycleLeft.image = UIImage(named: "Bicycle-Demo-1.jpg")
        imgBicycleRight.image = UIImage(named: "Bicycle-Demo-2.jpg")
        txtReturn.layer.cornerRadius = 4
        txtReturn.layer.borderWidth = 1
        txtReturn.layer.borderColor = UIColor.white.cgColor
        txtLock.layer.cornerRadius = 4
        txtLock.layer.borderWidth = 1
        txtLock.layer.borderColor = UIColor.white.cgColor
        loadData()
    }
    
    @IBAction func btnReturnTapped(_ sender: AnyObject) {
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/bicycle/return")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constants.token,
            "Accept": "application/json"
        ]
        let parameters: Parameters = [
            "bicycleId" : bicycle_id,
            "latitude" : Constants.curLat,
            "longitude" : Constants.curLong,
            "listBeacons" : Constants.beaconList
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "segueFeedback", sender: nil)
                }
                DispatchQueue.main.async(execute: {
                    self.Transfer.set(self.txtBookingID.text!, forKey: "fb_bookingId")
                    self.txtPickUpStation.isEnabled = false
                    self.loadData()
                })
            }
        }
    }
    @IBAction func btnPickUpTapped(_ sender: AnyObject) {
        let secondTab = self.tabBarController?.viewControllers![0] as! HomeNavigationController
        secondTab.btnPickUpStationTapped()
        self.tabBarController!.selectedIndex = 0
    }
    
    func loadData(){
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/rental/current-booking")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constants.token,
            "Accept": "application/json"
        ]
        let parameters: Parameters = [
            "bicycleId" : bicycle_id,
            "latitude" : Constants.curLat,
            "longitude" : Constants.curLong,
            "listBeacons" : Constants.beaconList
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                DispatchQueue.main.async(execute: {
                    self.viewEmpty.isHidden = true
                    
                    if let JSON = response.result.value as? [String: Any] {
                        self.txtBookingID.text = JSON["booking_id"] as? String
                        self.txtBicycleID.text = JSON["bicycle_id"] as? String
                        self.txtBrandModel.text = (JSON["brand"] as? String)! + "/" + (JSON["model"] as? String)!
                        self.txtAddress.text = (JSON["pickup_station_name"] as? String)! + ", " + (JSON["pickup_station_address"] as? String)!
                        self.txtBookedAt.text = JSON["book_at"] as? String
                        self.txtPickedAt.text = JSON["pickup_at"] as? String
                        
                        self.Transfer.set(JSON["pickup_station_name"] as? String, forKey: "pickUpStation")
                        self.Transfer.set(JSON["available_bicycle"] as? String, forKey: "pickUpStationAvailable")
                        self.Transfer.set(JSON["pickup_station_lat"] as? String, forKey: "pickUpLat")
                        self.Transfer.set(JSON["pickup_station_lng"] as? String, forKey: "pickUpLong")
                    }
                    DispatchQueue.main.async(execute: {
                        self.txtPickUpStation.isEnabled = true
                        
                    })
                })
            }
        }
    }
}
