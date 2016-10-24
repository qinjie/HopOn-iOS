//
//  BookingNavigationController.swift
//  HopOn
//
//  Created by Intern on 19/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit

class BookingNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func loadData(){
        self.popToRootViewController(animated: true)
        let secondTab = self.topViewController as! BookingController
        secondTab.loadData()
    }

}
