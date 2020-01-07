//
//  DisplayContainerViewController.swift
//  Mapping
//
//  Created by Findlay Wood on 26/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class DisplayContainerViewController: UIViewController, GMSMapViewDelegate ,  CLLocationManagerDelegate {
    
    var delegate: DisplaySavedViewController!
    
    var mapView : GMSMapView?
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = GMSMapView()
        
        mapView = GMSMapView.map(withFrame: .zero, camera: GMSCameraPosition.camera(withLatitude: 51.050657, longitude: 10.649514, zoom: 5.5))
        
        self.view = mapView
        mapView?.isMyLocationEnabled = true
        //mapView?.settings.myLocationButton = true
        mapView?.settings.compassButton = true
        mapView?.settings.zoomGestures = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //        let camera = (GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 15.0))
        //
        
        
        let camera = (GMSCameraPosition.camera(withLatitude: locationManager.location?.coordinate.latitude ?? 50.0, longitude: locationManager.location?.coordinate.longitude ?? 50.0, zoom: 15.0))
        
        
        self.mapView?.animate(to: camera)
        self.mapView?.camera = camera
        self.mapView?.delegate = self
        self.mapView?.isMyLocationEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        //marker.map = googleMaps
        marker.map = self.mapView
    }
    
    
//    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
//        self.mapView?.isMyLocationEnabled = true
//        self.mapView?.selectedMarker = nil
//        delegate.locationStart = (self.mapView?.myLocation!)!
//        delegate?.startLocation.text = "My Location"
//        return false
//    }
    
//    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
//        let marker = GMSMarker(position: coordinate)
//        marker.title = "End Point"
//        marker.map = mapView
//        delegate.destinationLocation.text = "\(coordinate.latitude), \(coordinate.longitude)"
//        delegate.locationEnd = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//    }
    
    func clear(_ mapView: GMSMapView){
        self.mapView?.clear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let signUpControllerParent = self.parent as! DisplaySavedViewController
        signUpControllerParent.saveContrainerViewRefference(vc: self)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
