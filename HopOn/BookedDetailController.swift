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
    var data: History!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

}
