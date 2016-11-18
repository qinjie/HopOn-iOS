//
//  HomeNavigationController.swift
//  HopOn
//
//  Created by Intern on 18/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func btnPickUpStationTapped(){
        let secondTab = self.topViewController as! ViewController
        secondTab.btnPickUpStationTapped()
    }
}
