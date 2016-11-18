//
//  BookingDetailController.swift
//  HopOn
//
//  Created by Intern on 8/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit

class BookedDetailController: UIViewController {

    
    
    @IBOutlet weak var txtBooking_id: UILabel!
    @IBOutlet weak var txtBrand_model: UILabel!
    @IBOutlet weak var txtBicycle_id: UILabel!
    @IBOutlet weak var txtPickUpStation: UILabel!
    @IBOutlet weak var txtBookedTime: UILabel!
    @IBOutlet weak var txtPickedTime: UILabel!
    @IBOutlet weak var txtReturnStation: UILabel!
    @IBOutlet weak var txtReturnTime: UILabel!
    @IBOutlet weak var txtDuration: UILabel!
    @IBOutlet weak var btnPickUpStation: UIButton!
    @IBOutlet weak var btnReturnStation: UIButton!
    var Transfer: UserDefaults!
    
    var data: History!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Transfer = UserDefaults()
        btnPickUpStation.setImage(UIImage(named: "Geo-fence-30.png"), for: UIControlState())
        btnReturnStation.setImage(UIImage(named: "Geo-fence-30.png"), for: UIControlState())
        txtBooking_id.text = data.booking_id
        txtBicycle_id.text = data.bicycle_id
        txtBrand_model.text = data.brand + "/" + data.model
        txtPickUpStation.text = data.pickup_station_name
        txtBookedTime.text = data.book_at
        txtPickedTime.text = data.pickup_at
        txtReturnStation.text = data.return_station_name
        txtReturnTime.text = data.return_at
        txtDuration.text = data.duration
    }

    @IBAction func btnPickUpStationTapped(_ sender: AnyObject) {
        self.Transfer.set(data.pickup_station_lat as String, forKey: "pickUpLat")
        self.Transfer.set(data.pickup_station_lng as String, forKey: "pickUpLong")
        let secondTab = self.tabBarController?.viewControllers![0] as! HomeNavigationController
        secondTab.btnPickUpStationTapped()
        self.tabBarController!.selectedIndex = 0
    }
    
    @IBAction func btnReturnStationTapped(_ sender: AnyObject) {
        self.Transfer.set(data.return_station_lat as String, forKey: "pickUpLat")
        self.Transfer.set(data.return_station_lng as String, forKey: "pickUpLong")
        let secondTab = self.tabBarController?.viewControllers![0] as! HomeNavigationController
        secondTab.btnPickUpStationTapped()
        self.tabBarController!.selectedIndex = 0
    }
    
    
}
