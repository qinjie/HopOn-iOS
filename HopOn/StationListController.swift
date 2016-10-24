//
//  StationListController.swift
//  HopOn
//
//  Created by Intern on 15/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire

class StationListController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var Transfer: UserDefaults!
    var stationArray = [Station]()
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        Transfer = UserDefaults()
        stationArray = Constants.station
        if (stationArray.count == 0){
            loadData()
        }
    }
    
    func loadData(){
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/station/search")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constants.token,
            "Accept": "application/json"
        ]
        let parameters: Parameters = [
            "latitude" : (String)(Constants.curLat),
            "longitude" :(String)(Constants.curLong)
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                let station = [Station](json: response.result.value)
                self.stationArray = station
                DispatchQueue.main.async(execute: {
                    self.refreshControl.endRefreshing()
                    self.tableView .reloadData()
                })
            }
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StationCell
        cell.txtName.text = stationArray[(indexPath as NSIndexPath).row].name
        cell.txtTotal.text = stationArray[(indexPath as NSIndexPath).row].bicycle_count + " bicycles"
        cell.txtAddress.text = stationArray[(indexPath as NSIndexPath).row].address
        cell.txtAvailable.text = stationArray[(indexPath as NSIndexPath).row].available_bicycle + " bicycles"
        cell.txtDistance.text = stationArray[(indexPath as NSIndexPath).row].distanceText
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selected = self.tableView.indexPath(for: sender as! UITableViewCell)
        let index:Int! = (selected as NSIndexPath?)?.row
        let vc = segue.destination as! BicycleBookingController
        let name: String = stationArray[index].name
        let address: String = stationArray[index].address
        let id: String = stationArray[index].id
        vc.station_name = name
        vc.station_address = address
        vc.station_id = id
    }
}
