//
//  StationListNavigationController.swift
//  HopOn
//
//  Created by Intern on 16/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit

class StationListNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData(){
        let secondTab = self.topViewController as! StationListController
        secondTab.loadData()
    }
    
    func btnDetailTapped(station_id: Int){
        let secondTab = self.topViewController as! StationListController
        secondTab.btnDetailTapped(station_id: station_id)
    }
    
    func afterBook(){
        self.popToRootViewController(animated: true)
    }
}
