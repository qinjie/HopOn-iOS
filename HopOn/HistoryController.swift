//
//  HistoryController.swift
//  HopOn
//
//  Created by Intern on 8/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import Alamofire
import EVReflection

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var Transfer: UserDefaults!
    var historyArray = [History]()
    let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: UIAlertControllerStyle.alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        //Wating dialog
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        Transfer = UserDefaults()
        loadData()
    }
    
    func loadData(){
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/rental/history")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constants.token,
            "Accept": "application/json"
        ]
        let parameters: Parameters = ["":""]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                let history = [History](json: response.result.value)
                self.historyArray = history
                DispatchQueue.main.async(execute: {
                    self.refreshControl.endRefreshing()
                    self.tableView .reloadData()
                    self.alertController.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryCell
        cell.txtBooked_at.text = historyArray[(indexPath as NSIndexPath).row].book_at
        cell.txtBooked_add.text = historyArray[(indexPath as NSIndexPath).row].pickup_station_name
        cell.txtReturn_add.text = historyArray[(indexPath as NSIndexPath).row].return_station_name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selected = self.tableView.indexPath(for: sender as! UITableViewCell)
        let index:Int! = (selected as NSIndexPath?)?.row
        let destination = segue.destination as! BookedDetailController
        destination.data = historyArray[index]
    }
}
