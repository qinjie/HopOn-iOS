//
//  BookingController.swift
//  HopOn
//
//  Created by Intern on 5/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire
import Bean_iOS_OSX_SDK

class BookingController: UIViewController, PTDBeanManagerDelegate, PTDBeanDelegate{

    @IBOutlet weak var btnPickUpStation: UIButton!
    @IBOutlet weak var imgBicycleLeft: UIImageView!
    @IBOutlet weak var imgBicycleRight: UIImageView!
    @IBOutlet weak var txtBookingID: UILabel!
    @IBOutlet weak var txtBrandModel: UILabel!
    @IBOutlet weak var txtBicycleID: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var txtBookedAt: UILabel!
    @IBOutlet weak var txtPickedAt: UILabel!
    @IBOutlet weak var txtPickUpStation: UIButton!
    @IBOutlet weak var txtReturn: UIButton!
    @IBOutlet weak var txtLock: UIButton!
    @IBOutlet weak var txtState: UIButton!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var txtSerial: UILabel!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var txtEmpty: UILabel!
    var Transfer: UserDefaults!
    var beanManager: PTDBeanManager?
    var yourBean: PTDBean?
    var query: String = ""
    var enc: String = ""
    var auth_key: String = ""
    var bicycle_serial: String = ""
    var alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: UIAlertControllerStyle.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Wating dialog
        alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
        
        
        imgEmpty.layer.shadowColor = UIColor.black.cgColor
        imgEmpty.layer.shadowOpacity = 1
        imgEmpty.layer.shadowOffset = CGSize.zero
        imgEmpty.layer.shadowRadius = 5
        
        beanManager = PTDBeanManager()
        beanManager!.delegate = self
        var error: NSError?
        beanManager!.startScanning(forBeans_error: &error)
        txtPickUpStation.isEnabled = false
        self.viewEmpty.isHidden = false
        Transfer = UserDefaults()
        btnPickUpStation.setImage(UIImage(named: "Geo-fence-30.png"), for: UIControlState())
        txtState.setImage(UIImage(named: "State_Fail.png"), for: UIControlState())
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
    
    override func viewDidAppear(_ animated: Bool) {
        startScanning()
    }
    @IBAction func btnUnlockTapped(_ sender: AnyObject) {
        if (self.txtLock.titleLabel?.text == "Unlock"){
            self.txtLock.isEnabled = false
            self.query = enc + "," + auth_key + ",1"
            txtLock.setTitle("Lock", for: .normal)
            let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/bicycle/unlock")
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Constants.token,
                "Accept": "application/json"
            ]
            let parameters: Parameters = [
                "bicycleId" : self.txtBicycleID.text!,
                "latitude": Constants.curLat,
                "longitude": Constants.curLong
            ]
            
            Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                let statusCode = response.response?.statusCode
                if (statusCode == 200){
                }
                DispatchQueue.main.async(execute: {
                    self.txtLock.isEnabled = true
                    self.alertController.dismiss(animated: true, completion: nil)
                })
            }
        }
        else{
            self.txtLock.isEnabled = false
            self.query = enc + "," + auth_key + ",2"
            txtLock.setTitle("Unlock", for: .normal)
            let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/bicycle/lock")
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Constants.token,
                "Accept": "application/json"
            ]
            let parameters: Parameters = [
                "bicycleId" : self.txtBicycleID.text!,
                "latitude": Constants.curLat,
                "longitude": Constants.curLong
            ]
            
            Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                let statusCode = response.response?.statusCode
                if (statusCode == 200){
                }
                
                DispatchQueue.main.async(execute: {
                    self.txtLock.isEnabled = true
                    self.alertController.dismiss(animated: true, completion: nil)
                })
            }
        }
        let data = query.data(using: String.Encoding.utf8)!
        sendSerialData(beanState: data as NSData)
    }
    
    @IBAction func btnStateTapped(_ sender: AnyObject) {
        startScanning()
    }
    
    
    @IBAction func btnReturnTapped(_ sender: AnyObject) {
        //Wating dialog
        alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/bicycle/return")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constants.token,
            "Accept": "application/json"
        ]
        let beaconsJson = BeaconObj.jsonArray(array: Constants.beaconList)
        let parameters: Parameters = [
            "bicycleId" : self.txtBicycleID.text!,
            "latitude" : Constants.curLat,
            "longitude" : Constants.curLong,
            "listBeacons" : beaconsJson
        ]
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                let secondTab = self.tabBarController?.viewControllers![1] as! StationListNavigationController
                secondTab.loadData()
                DispatchQueue.main.async(execute: {
                    self.Transfer.set(self.txtBookingID.text!, forKey: "fb_bookingId")
                    self.Transfer.set(self.txtBookingID.text!, forKey: "fb_bookingId")
                    self.txtPickUpStation.isEnabled = false
                    self.query = self.enc + "," + self.auth_key + ",3"
                    let data = self.query.data(using: String.Encoding.utf8)!
                    self.sendSerialData(beanState: data as NSData)
                    self.loadData()
                })
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "segueFeedback", sender: nil)
                }
            }
            else{
                OperationQueue.main.addOperation {                    
                    self.alertController.dismiss(animated: true, completion: nil)
                    let alertController = UIAlertController(title: "", message:
                        "Return unsuccessfully", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }.resume()
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
        let parameters: Parameters = ["":""]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                DispatchQueue.main.async(execute: {
                    self.viewEmpty.isHidden = true
                    if let JSON = response.result.value as? [String: Any] {
                        self.bicycle_serial = (JSON["bicycle_serial"] as? String)!
                        self.enc = (JSON["enc"] as? String)!
                        self.auth_key = (JSON["auth_key"] as? String)!
                        self.txtBookingID.text = JSON["booking_id"] as? String
                        self.txtSerial.text = JSON["bicycle_serial"] as? String
                        self.txtBicycleID.text = JSON["bicycle_id"] as? String
                        self.txtBrandModel.text = (JSON["brand"] as? String)! + "/" + (JSON["model"] as? String)!
                        self.txtAddress.text = (JSON["pickup_station_name"] as? String)! + ", " + (JSON["pickup_station_address"] as? String)!
                        self.txtBookedAt.text = JSON["book_at"] as? String
                        self.txtPickedAt.text = JSON["pickup_at"] as? String
                        
                        self.Transfer.set(JSON["pickup_station_name"] as? String, forKey: "pickUpStation")
                        self.Transfer.set(JSON["rental_id"] as? String, forKey: "rental_id")
                        //                        self.Transfer.set(JSON["available_bicycle"] as? String, forKey: "pickUpStationAvailable")
                        self.Transfer.set(JSON["pickup_station_lat"] as? String, forKey: "pickUpLat")
                        self.Transfer.set(JSON["pickup_station_lng"] as? String, forKey: "pickUpLong")
                        self.txtPickUpStation.isEnabled = true
                        self.alertController.dismiss(animated: true, completion: nil)
                    }
                })
            }
            else{
                DispatchQueue.main.async(execute: {
                    self.viewEmpty.isHidden = false
                    self.alertController.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    func beanManagerDidUpdateState(_ beanManager: PTDBeanManager!) {
        var scanError: NSError?
        
        if beanManager!.state == BeanManagerState.poweredOn {
            startScanning()
            if var e = scanError {
                print(e)
            } else {
                print("Please turn on your Bluetooth")
            }
        }
    }
    
    func bean(_ bean: PTDBean!, serialDataReceived data: Data!) {
        var string_data: String
        string_data = String(data: data, encoding: String.Encoding.utf8)!
        print(string_data)
    }

    
    func startScanning() {
        var error: NSError?
        beanManager!.startScanning(forBeans_error: &error)
        if let e = error {
            print(e)
        }
    }
    
    func beanManager(_ beanManager: PTDBeanManager!, didDiscover bean: PTDBean!, error: Error!) {
        if (bicycle_serial != "" && bean.name == bicycle_serial) {
            yourBean = bean
            connectToDevice(yourBean!)
            print("Connected to " + bicycle_serial)
            self.txtState.setImage(UIImage(named: "State_OK.png"), for: UIControlState())
        } else {
            print("Found a Bean not names " + bicycle_serial)
        }
    }
    
    func connectToDevice(_ device: PTDBean) {
        var error: NSError?
        beanManager?.connect(to: device, withOptions:nil, error: &error)
        yourBean?.delegate = self
    }
    
    func sendSerialData(beanState: NSData) {
        yourBean?.sendSerialData(beanState as Data!)
    }
    
    func disconnectBean(){
        var error: NSError?
        if ((yourBean) != nil){
            beanManager?.disconnect(fromAllBeans: &error)
        }
    }
}
