//
//  SavePageViewController.swift
//  Mapping
//
//  Created by Findlay Wood on 25/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreData
import Flurry_iOS_SDK


class SavePageViewController: UIViewController, GMSMapViewDelegate ,  CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    
    @IBOutlet var startLocation: UITextField!
    @IBOutlet var endLocation: UITextField!
    @IBOutlet var routeName: UITextField!
    
    @IBAction func startPressed(_ sender: UIButton){
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        self.locationSelected = .startLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        //self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func endPressed(_ sender: UIButton){
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        self.locationSelected = .destinationLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        //self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender:UIButton){
        if startLocation.text == "" || endLocation.text == "" || routeName.text == ""{
            let alert = UIAlertController(title: "Oops", message: "Please fill in all the fields to save a route.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "SavedRoutes", in: context)
            let newRoute = NSManagedObject(entity: entity!, insertInto: context)
            
            newRoute.setValue(Double(locationStart.coordinate.latitude), forKey: "startlat")
            newRoute.setValue(Double(locationStart.coordinate.longitude), forKey: "startlong")
            newRoute.setValue(Double(locationEnd.coordinate.latitude), forKey: "endlat")
            newRoute.setValue(Double(locationEnd.coordinate.longitude), forKey: "endlong")
            newRoute.setValue(routeName.text, forKey: "name")
            newRoute.setValue(startLocation.text, forKey: "startname")
            newRoute.setValue(endLocation.text, forKey: "endname")
            
            do {
                try context.save()
                let alert = UIAlertController(title: "Route Saved", message: "Your route has been saved.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                startLocation.text = ""
                endLocation.text = ""
                routeName.text = ""
                
            } catch {
                print("Failed saving")
                let alert = UIAlertController(title: "Error", message: "Failed to save route. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                startLocation.text = ""
                endLocation.text = ""
                routeName.text = ""
            }
        }
        Flurry.logEvent("Saved Route")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        let context = appDelegate.persistentContainer.viewContext
        
        self.navigationController?.navigationBar.isHidden = false
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - GMS Auto Complete Delegate, for autocomplete search location
extension SavePageViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Change map location
        //        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
        //        )
        
        // set coordinate to text
        if self.locationSelected == .startLocation {
            startLocation.text = "\(place.name)"
            locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            //            infoRegisterRefferenceVC?.createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "Map Pin-96"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        } else {
            endLocation.text = "\(place.name)"
            locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            //            infoRegisterRefferenceVC?.createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "Map Pin-96"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        }
        
        
        //self.googleMaps.camera = camera
        //self.mapView?.camera = camera
        //infoRegisterRefferenceVC?.mapView?.camera = camera
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}

