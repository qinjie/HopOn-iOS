//
//  ViewController.swift
//  HopOn
//
//  Created by Intern on 5/8/16.
//  Copyright © 2016 Intern. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var btnCurrent: UIButton!
    var selectedPin: MKPlacemark?
    var lastAnno: SearchAnno? = nil
    var curLocation = CLLocationCoordinate2D()
    var resultSearchController: UISearchController!
    let locationManager = CLLocationManager()
    var Transfer: UserDefaults!
    let regionBeacon = CLBeaconRegion(proximityUUID: UUID(uuidString: "23A01AF0-232A-4518-9C0E-323FB773F5EF")!, identifier: "Sensoro")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Transfer = UserDefaults()
        btnCurrent.layer.shadowColor = UIColor.gray.cgColor
        btnCurrent.layer.shadowOpacity = 1
        btnCurrent.layer.shadowOffset = CGSize.zero
        btnCurrent.layer.shadowRadius = 1
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestLocation()
        locationManager.startRangingBeacons(in: regionBeacon)
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        loadData()
        
        btnCurrent.addTarget(self, action: #selector(btnCurrentAction), for: .touchUpInside)
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let loc = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        curLocation = (locationManager.location?.coordinate)!
        let curRegion = MKCoordinateRegion(center: loc, span: span)
        mapView.setRegion(curRegion, animated: true)
    }
    
    func btnPickUpStationTapped(){
        let pickUpLat = (Double)(Transfer.object(forKey: "pickUpLat") as! String)
        let pickUpLong = (Double)(Transfer.object(forKey: "pickUpLong") as! String)
        if (pickUpLat != 0.0 && pickUpLong != 0.0){
//            let pickUpStation = Transfer.object(forKey: "pickUpStation") as! String
//            let pickUpStationAvailable = Transfer.object(forKey: "pickUpStationAvailable") as! String
//            let pickUpStationCoor = CLLocationCoordinate2DMake(pickUpLat!, pickUpLong!)
//            let pickUpStationAnno = MKPointAnnotation()
//            pickUpStationAnno.coordinate = pickUpStationCoor
//            pickUpStationAnno.title = pickUpStation
//            pickUpStationAnno.subtitle = "Available: " + pickUpStationAvailable
//            mapView.addAnnotation(pickUpStationAnno)
            
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let loc = CLLocationCoordinate2DMake(pickUpLat!, pickUpLong!)
            let region = MKCoordinateRegion(center: loc, span: span)
            mapView.setRegion(region, animated: true)
            
            self.Transfer.set("0.0", forKey: "pickUpStation")
            self.Transfer.set("0.0", forKey: "pickUpStation")
        }
        else{
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let loc = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
            curLocation = (locationManager.location?.coordinate)!
            let region = MKCoordinateRegion(center: loc, span: span)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func loadData(){
        let latitude = NSString(format: "%f", (locationManager.location?.coordinate.latitude)!)
        let longitude = NSString(format: "%f", (locationManager.location?.coordinate.longitude)!)
        let url = URL(string: Constants.baseURL + "/hopon-web/api/web/index.php/v1/station/search")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constants.token,
            "Accept": "application/json"
        ]
        let parameters: Parameters = [
            "latitude" : latitude,
            "longitude" : longitude
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
            let statusCode = response.response?.statusCode
            if (statusCode == 200){
                let station = [Station](json: response.result.value)
                Constants.station = station
                DispatchQueue.main.async(execute: {
                    for item in station{
                        let dLat: Double = (Double)(item.latitude!)!
                        let dLong: Double = (Double)(item.longitude!)!
                        let Point = CLLocationCoordinate2DMake(dLat, dLong)
                        //let pin = MKPointAnnotation()
                        //pin.coordinate = Point
                        //pin.title = item.name
                        //pin.subtitle = "Available: " + item.available_bicycle!
                        //self.mapView.addAnnotation(pin)
                        let stationAnno = StationAnno(title: item.name, coordinate: Point, subtitle: "Available: " + item.available_bicycle!)
                        self.mapView.addAnnotation(stationAnno)
                    }
                })
            }
        }

    }
    
    func btnCurrentAction(_ sender: UIButton!) {
        if (curLocation.latitude != 0.0 && curLocation.longitude != 0.0){
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let region = MKCoordinateRegion(center: curLocation, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
}


extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        var beaconList = [BeaconObj]()
        for beacon in knownBeacons{
            let uuid = (String)(beacon.proximityUUID.uuidString)
            let major = (String)(describing: beacon.major)
            let minor = (String)(describing: beacon.minor)
            let rssi = (String)(beacon.rssi)
            let beaconObj = BeaconObj(uuid: uuid, major: major, minor: minor, rssi: rssi)
            beaconList.append(beaconObj)
        }
        Constants.beaconList = beaconList
//        if (knownBeacons.count > 0) {
//            let closestBeacon = knownBeacons[0] as CLBeacon
//            let uuid = (String)(closestBeacon.proximityUUID.uuidString)
//            let major = (String)(describing: closestBeacon.major)
//            let minor = (String)(describing: closestBeacon.minor)
//            print((String)(major) + "-" + (String)(minor))
//            self.Transfer.set(uuid, forKey: "uuid")
//            self.Transfer.set(major, forKey: "major")
//            self.Transfer.set(minor, forKey: "minor")
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        curLocation = location.coordinate
        mapView.setRegion(region, animated: true)
        Constants.curLat = (Double)((locationManager.location?.coordinate.latitude)!)
        Constants.curLong = (Double)((locationManager.location?.coordinate.longitude)!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension ViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        // mapView.removeAnnotations(mapView.annotations)
        if (lastAnno != nil){
            mapView.removeAnnotation(lastAnno!)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        //mapView.addAnnotation(annotation)
        let searchAnno = SearchAnno(title: annotation.title!, coordinate: annotation.coordinate, subtitle: annotation.subtitle!)
        lastAnno = searchAnno
        self.mapView.addAnnotation(searchAnno)
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
    }
    
}

extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        if annotation is StationAnno {
            let annotationIdentifier = "Station"
            
            var annotationView: MKAnnotationView?
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
                annotationView = dequeuedAnnotationView
                annotationView?.annotation = annotation
            }
            else {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                let buttonDetail = UIButton(type: .detailDisclosure)
                buttonDetail.addTarget(self, action: #selector(detail), for: .touchUpInside)
                annotationView?.rightCalloutAccessoryView = buttonDetail
            }
            if let annotationView = annotationView {
                // Configure your annotation view here
                let size = CGSize(width: 40, height: 40)
                let image = UIImage(named: "Bicycle.png")
                annotationView.image = image?.af_imageAspectScaled(toFit: size)
                annotationView.canShowCallout = true
                let smallSquare = CGSize(width: 30, height: 30)
                let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
                button.setBackgroundImage(UIImage(named: "Get-Direction.png"), for: UIControlState())
                button.addTarget(self, action: #selector(ViewController.getDirections), for: .touchUpInside)
                annotationView.leftCalloutAccessoryView = button
            }
            return annotationView
        }
        if annotation is SearchAnno{
            let identifier = "Search"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView?.pinTintColor = UIColor.orange
            pinView?.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "Get-Direction.png"), for: UIControlState())
            button.addTarget(self, action: #selector(ViewController.getDirections), for: .touchUpInside)
            pinView?.leftCalloutAccessoryView = button
            return pinView
        }
        return nil
    }
    
    func detail(){
        let secondTab = self.tabBarController?.viewControllers![1] as! StationListNavigationController
        secondTab.btnDetailTapped(station_id: 0)
        self.tabBarController!.selectedIndex = 1
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedLoc = view.annotation
        selectedPin = MKPlacemark(coordinate: selectedLoc!.coordinate, addressDictionary: nil)
    }
}
