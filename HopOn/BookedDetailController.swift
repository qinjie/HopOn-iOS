//
//  BookingDetailController.swift
//  HopOn
//
//  Created by Intern on 8/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit

class BookingDetailController: UIViewController {

    @IBOutlet weak var btnPickUpStation: UIButton!
    @IBOutlet weak var btnReturnStation: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPickUpStation.setImage(UIImage(named: "Geo-fence-30.png"), forState: UIControlState.Normal)
        btnReturnStation.setImage(UIImage(named: "Geo-fence-30.png"), forState: UIControlState.Normal)
    }

}
