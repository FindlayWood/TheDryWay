//
//  DisplaySavedViewController.swift
//  Mapping
//
//  Created by Findlay Wood on 26/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class DisplaySavedViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var startText = String()
    var endText = String()
    var name = String()
    
    var polyline : GMSPolyline?
    var polyline2 : GMSPolyline?
    
    @IBOutlet var startLButton: UIButton!
    @IBOutlet var endLButton: UIButton!
    @IBOutlet var showDButton: UIButton!
    @IBOutlet var blueRButton: UIButton!
    @IBOutlet var greenRButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var helpButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    //value for holding temperature
    var temperatures:String!
    var currentTemperatures = [Double]()
    var celsius:String!
    var fahrenheit:String!
    
    //arrays to hold values for blue route
    var precipIstart = [Double]()
    var precipIend = [Double]()
    var precipMid = [Double]()
    var weatherPoints = [Double]()
    var startProb = [Double]()
    var endProb = [Double]()
    var midProb = [Double]()
    
    //arrays to hold values for the green route
    var precipIend2 = [Double]()
    var precipMid2 = [Double]()
    var startProb2 = [Double]()
    var endProb2 = [Double]()
    var midProb2 = [Double]()
    var routes:Int = 0
    
    var points = [CLLocationCoordinate2D]()
    var metres = [Int]()
    //arrays for the green route to hold points and metres
    var points2 = [CLLocationCoordinate2D]()
    var metres2 = [Int]()
    
    
    var pointsToBeCalc = [CLLocationCoordinate2D]()
    var addedPoints = [Double]()
    
    var counter = 0
    
    var valid = false
    
    var pointsToBeCalc2 = [CLLocationCoordinate2D]()
    var addedPoints2 = [Double]()
    
    var counter2 = 0
    
    var valid2 = false
    
    
    var totalDistance:String = ""
    var totalDuration:String = ""
    
    var distance:UInt = 0
    var duration:UInt = 0
    
    var transportMethod:String = "bicycling"
    
    
    
    @IBOutlet var bicyclingButton: UIButton!
    @IBOutlet var walkingButton: UIButton!
    @IBOutlet var drivingButton: UIButton!
    
    var infoRegisterRefferenceVC : DisplayContainerViewController?
    
    func saveContrainerViewRefference(vc:DisplayContainerViewController){
        
        self.infoRegisterRefferenceVC = vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        //self.navigationController?.navigationItem.title = "\(name)"
        navigationItem.title = "\(name)"
        if startText != ""{
            startLocation.text = "\(startText)"
        }
        if endText != ""{
            destinationLocation.text = "\(endText)"
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func walkButton(_ sender: UIButton) {
        //clear(mapView!)
        if startLocation.text == "" || destinationLocation.text == ""{
            let alert = UIAlertController(title: "Oops!", message: "You must have a start and end location to create a route.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else{
            polyline?.map = nil
            polyline2?.map = nil
            self.routes = 0
            transportMethod = "walking"
            walkingButton.isSelected = true
            bicyclingButton.isSelected = false
            drivingButton.isSelected = false
            removingFromArrays()
            drawPath(startLocation: locationStart, endLocation: locationEnd)
            waypoints(startLocation: locationStart, endLocation: locationEnd)
            //distanceAndTime(startLocation: locationStart, endLocation: locationEnd)
        }
        
        
        
    }
    
    @IBAction func bikeButton(_ sender: UIButton) {
        //clear(mapView!)
        if startLocation.text == "" || destinationLocation.text == ""{
            let alert = UIAlertController(title: "Oops!", message: "You must have a start and end location to create a route.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else{
            polyline?.map = nil
            polyline2?.map = nil
            self.routes = 0
            transportMethod = "bicycling"
            bicyclingButton.isSelected = true
            walkingButton.isSelected = false
            drivingButton.isSelected = false
            removingFromArrays()
            drawPath(startLocation: locationStart, endLocation: locationEnd)
            waypoints(startLocation: locationStart, endLocation: locationEnd)
            //distanceAndTime(startLocation: locationStart, endLocation: locationEnd)
        }
        
    }
    
    @IBAction func driveButton(_ sender: UIButton) {
        //clear(mapView!)
        if startLocation.text == "" || destinationLocation.text == ""{
            let alert = UIAlertController(title: "Oops!", message: "You must have a start and end location to create a route.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else{
            polyline?.map = nil
            polyline2?.map = nil
            self.routes = 0
            transportMethod = "driving"
            drivingButton.isSelected = true
            walkingButton.isSelected = false
            bicyclingButton.isSelected = false
            removingFromArrays()
            drawPath(startLocation: locationStart, endLocation: locationEnd)
            waypoints(startLocation: locationStart, endLocation: locationEnd)
            //distanceAndTime(startLocation: locationStart, endLocation: locationEnd)
        }
        
    }
    
    func clear(_ mapView: GMSMapView){
        infoRegisterRefferenceVC?.mapView?.clear()
        //self.mapView?.clear()
    }
    
    
    @IBAction func clearButton(_ sender: Any) {
        clear((infoRegisterRefferenceVC?.mapView)!)
        //clear(self.mapView!)
        self.routes = 0
        removing()
        removingFromArrays()
    }
    
    func deselectButtons(){
        walkingButton.isSelected = false
        drivingButton.isSelected = false
        bicyclingButton.isSelected = false
    }
    
    //resetting the location textfields and coordinates
    func removing(){
        startLocation.text = ""
        destinationLocation.text = ""
        locationStart = CLLocation(latitude: 0, longitude: 0)
        locationEnd = CLLocation(latitude: 0, longitude: 0)
        deselectButtons()
    }
    
    func removingFromArrays(){
        self.precipMid.removeAll()
        self.precipIstart.removeAll()
        self.precipIend.removeAll()
        self.startProb.removeAll()
        self.midProb.removeAll()
        self.endProb.removeAll()
        self.points.removeAll()
        self.metres.removeAll()
        self.pointsToBeCalc.removeAll()
        self.precipMid2.removeAll()
        self.midProb2.removeAll()
        self.points2.removeAll()
        self.metres2.removeAll()
        self.pointsToBeCalc2.removeAll()
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation){
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let method = transportMethod
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=\(method)&alternatives=true&key=AIzaSyA0AWNtlmlZZnY7eE00JhZkI2GW2APbrYg"
        
        Alamofire.request(url).responseJSON { response in
            
            let json = try? JSON(data: response.data!)
            //print(json!)
            let routes = json!["routes"].arrayValue
            
            
            // print route using Polyline
            
            if routes.count > 1{
                self.polyline2 = GMSPolyline()
                let route2 = routes[1]
                let rOP2 = route2["overview_polyline"].dictionary
                let points2 = rOP2?["points"]?.stringValue
                let path2 = GMSPath.init(fromEncodedPath: points2!)
                self.polyline2 = GMSPolyline.init(path: path2)
                self.polyline2?.strokeWidth = 5
                self.polyline2?.strokeColor = UIColor.green
                //polyline2.map = self.googleMaps
                self.polyline2?.map = self.infoRegisterRefferenceVC?.mapView
                //self.polyline2?.map = self.mapView
            }
            
            if routes.count > 0{
                self.polyline = GMSPolyline()
                let route1 = routes[0]
                let rOP = route1["overview_polyline"].dictionary
                let points = rOP?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                self.polyline = GMSPolyline.init(path: path)
                self.polyline?.strokeWidth = 5
                self.polyline?.strokeColor = UIColor.blue
                //polyline.map = self.googleMaps
                self.polyline?.map = self.infoRegisterRefferenceVC?.mapView
                //self.polyline?.map = self.mapView
                DispatchQueue.main.async {
                    if self.infoRegisterRefferenceVC?.mapView != nil{
                        let bounds = GMSCoordinateBounds(path: path!)
                        self.infoRegisterRefferenceVC?.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
                    }
                    //                    if self.mapView != nil{
                    //                        let bounds = GMSCoordinateBounds(path: path!)
                    //                        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 120.0))
                    //                    }
                }
            }
            
            if routes.count > 1{
                self.routes = 2
            }
                
            else if routes.count == 0 {
                let alert = UIAlertController(title: "Error", message: "No routes available. Please enter a different start and end location.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func distanceAndTime(startLocation: CLLocation, endLocation: CLLocation){
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let method = transportMethod
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=\(method)&key=AIzaSyA0AWNtlmlZZnY7eE00JhZkI2GW2APbrYg"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let data = data{
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let route = json["routes"] as? [[String:Any]]{
                            for r in route{
                                if let legs = r["legs"] as? [[String:Any]]{
                                    for leg in legs{
                                        if let distance = leg["distance"] as? [String:Any]{
                                            if let d = distance["text"] as? String{
                                                self.totalDistance = d
                                                print(self.totalDistance)
                                            }
                                            
                                        }
                                        if let duration = leg["duration"] as? [String:Any]{
                                            
                                            if let dr = duration["text"] as? String{
                                                self.totalDuration = dr
                                                print(self.totalDuration)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                }catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        task.resume()
        self.dist2 = "Distance = \(self.totalDistance) Duration = \(self.totalDuration)"
    }
    
    func waypoints(startLocation: CLLocation, endLocation: CLLocation){
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let method = transportMethod
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=\(method)&alternatives=true&key=AIzaSyA0AWNtlmlZZnY7eE00JhZkI2GW2APbrYg"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let data = data{
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        //print(json)
                        if let routes = json["routes"] as? [[String:Any]]{
                            
                            /*if routes.count == 0 {
                             let alert = UIAlertController(title: "Error", message: "Route not selected. Please enter a start and end location.", preferredStyle: UIAlertControllerStyle.alert)
                             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                             self.present(alert, animated: true, completion: nil)
                             }*/
                            
                            if routes.count > 0 {
                                let route1 = routes[0]
                                if let legs = route1["legs"] as? [[String:Any]]{
                                    for leg in legs{
                                        if let steps = leg["steps"] as? [[String:Any]]{
                                            for step in steps{
                                                if let start_l = step["start_location"] as? [String:Any]{
                                                    let lat = start_l["lat"] as? Double
                                                    let lon = start_l["lng"] as? Double
                                                    let coordinate = CLLocationCoordinate2DMake(lat!, lon!)
                                                    self.points.append(coordinate)
                                                }
                                                if let dist = step["duration"] as? [String:Any]{
                                                    if let metres = dist["value"] as? Int{
                                                        var minutes = metres/60
                                                        let remainder = metres%60
                                                        if (minutes == 0){
                                                            if remainder > 30{
                                                                minutes = 1
                                                            }else{
                                                                minutes = 0
                                                            }
                                                        }
                                                        self.metres.append(minutes)
                                                    }
                                                }
                                            }
                                            let sv = UIViewController.displaySpinner(onView: self.view)
                                            self.calcWeatherPoints()
                                            UIViewController.removeSpinner(spinner: sv)
                                        }
                                    }
                                }
                            }
                            
                            
                            if routes.count > 1{
                                let route2 = routes[1]
                                if let legs = route2["legs"] as? [[String:Any]]{
                                    for leg in legs{
                                        if let steps = leg["steps"] as? [[String:Any]]{
                                            for step in steps{
                                                if let start_l = step["start_location"] as? [String:Any]{
                                                    let lat = start_l["lat"] as? Double
                                                    let lon = start_l["lng"] as? Double
                                                    let coordinate = CLLocationCoordinate2DMake(lat!, lon!)
                                                    self.points2.append(coordinate)
                                                }
                                                if let dist = step["duration"] as? [String:Any]{
                                                    if let metres = dist["value"] as? Int{
                                                        var minutes = metres/60
                                                        let remainder = metres%60
                                                        if (minutes == 0){
                                                            if remainder > 30{
                                                                minutes = 1
                                                            }else{
                                                                minutes = 0
                                                            }
                                                        }
                                                        self.metres2.append(minutes)
                                                    }
                                                }
                                            }
                                            let sv = UIViewController.displaySpinner(onView: self.view)
                                            self.calcWeatherPoints2()
                                            UIViewController.removeSpinner(spinner: sv)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print("big MisTAKE no data collected")
                }
            }
            
        }
        //calcWeatherPoints()
        task.resume()
    }
    
    func calcWeatherPoints(){
        var index = 0
        print("metres count", metres.count)
        for _ in points{
            self.counter += metres[index]
            print("counter", counter)
            if self.counter >= 6{
                var valid = true
                while valid == true{
                    let top = Double(5 - (self.counter - metres[index]))
                    let prev = self.counter - metres[index]
                    let next = metres[index]
                    let bottom = Double(metres[index])
                    let p = Double(top/bottom)
                    let xprev = points[index].latitude
                    let yprev = points[index].longitude
                    if index+1 >= points.count{
                        break
                    }
                    let xnext = points[index+1].latitude
                    let ynext = points[index+1].longitude
                    let x = ((xnext - xprev) * p) + xprev
                    let y = ((ynext - yprev) * p) + yprev
                    let newpoint = CLLocationCoordinate2DMake(x, y)
                    points.insert(newpoint, at: index+1)
                    pointsToBeCalc.append(newpoint)
                    self.midWeather(midLocation: newpoint)
                    
                    let r = 5 - prev
                    let t = next - r
                    self.counter = t
                    metres.insert(t, at: index+1)
                    
                    if counter > 5{
                        valid = true
                        index += 1
                    }
                    else{
                        valid = false
                        if counter < 5 {
                            counter = 0
                        }
                    }
                }
            }
            if counter == 5{
                if index+1 < points.count{
                    pointsToBeCalc.append(points[index+1])
                    self.midWeather(midLocation: points[index+1])
                    self.counter = 0
                }
            }
            index += 1
        }
        /*for point in pointsToBeCalc{
         self.midWeather(midLocation: point)
         }*/
        print("points to be", pointsToBeCalc.count)
        self.startWeather(startLocation: locationStart)
        self.endWeather(endLocation: locationEnd)
        valid = true
    }
    
    //varibales for the green route
    //var pointsToBeCalc2 = [CLLocationCoordinate2D]()
    //var addedPoints2 = [Double]()
    
    //var counter2 = 0
    
    //var valid2 = false
    
    //to calculate the green route
    func calcWeatherPoints2(){
        var index = 0
        print("metres count", metres.count)
        for _ in points2{
            self.counter2 += metres2[index]
            print("counter", counter2)
            if self.counter2 >= 6{
                var valid2 = true
                while valid2 == true{
                    let top = Double(5 - (self.counter2 - metres2[index]))
                    let prev = self.counter2 - metres2[index]
                    let next = metres2[index]
                    let bottom = Double(metres2[index])
                    let p = Double(top/bottom)
                    let xprev = points2[index].latitude
                    let yprev = points2[index].longitude
                    if index+1 >= points2.count{
                        break
                    }
                    let xnext = points2[index+1].latitude
                    let ynext = points2[index+1].longitude
                    let x = ((xnext - xprev) * p) + xprev
                    let y = ((ynext - yprev) * p) + yprev
                    let newpoint = CLLocationCoordinate2DMake(x, y)
                    points2.insert(newpoint, at: index+1)
                    pointsToBeCalc2.append(newpoint)
                    self.midWeather2(midLocation: newpoint)
                    
                    let r = 5 - prev
                    let t = next - r
                    self.counter2 = t
                    metres2.insert(t, at: index+1)
                    
                    if counter2 > 5{
                        valid2 = true
                        index += 1
                    }
                    else{
                        valid2 = false
                        if counter2 < 5 {
                            counter2 = 0
                        }
                    }
                }
            }
            if counter2 == 5{
                if index+1 < points2.count{
                    pointsToBeCalc2.append(points2[index+1])
                    self.midWeather2(midLocation: points2[index+1])
                    self.counter2 = 0
                }
            }
            index += 1
        }
        /*for point in pointsToBeCalc{
         self.midWeather(midLocation: point)
         }*/
        print("points to be", pointsToBeCalc2.count)
        valid2 = true
    }
    
    //arrays created to hold values for the blue route
    var xAxisPoints = [Double]()
    var xAxisProb = [Double]()
    var xAxisPoints5 = [Double]()
    var xAxisPoints10 = [Double]()
    var xAxisPoints15 = [Double]()
    var xAxisPoints20 = [Double]()
    var xAxisPoints25 = [Double]()
    var xAxisPoints30 = [Double]()
    var xAxisProb5 = [Double]()
    var xAxisProb10 = [Double]()
    var xAxisProb15 = [Double]()
    var xAxisProb20 = [Double]()
    var xAxisProb25 = [Double]()
    var xAxisProb30 = [Double]()
    
    var addedValues = [Double]()
    var addedProb = [Double]()
    
    //same arrays created to hold the values for the green route
    var xAxisPoints2 = [Double]()
    var xAxisProb2 = [Double]()
    var xAxisPoints52 = [Double]()
    var xAxisPoints102 = [Double]()
    var xAxisPoints152 = [Double]()
    var xAxisPoints202 = [Double]()
    var xAxisPoints252 = [Double]()
    var xAxisPoints302 = [Double]()
    var xAxisProb52 = [Double]()
    var xAxisProb102 = [Double]()
    var xAxisProb152 = [Double]()
    var xAxisProb202 = [Double]()
    var xAxisProb252 = [Double]()
    var xAxisProb302 = [Double]()
    
    var addedValues2 = [Double]()
    var addedProb2 = [Double]()
    
    
    
    func allXAxis(points: inout [Double], probs: inout [Double], start: Int, constant: Int, constant2: Int, value: Int, addedV: inout [Double], addedP: inout [Double]){
        points.append(precipIstart[start])
        probs.append(startProb[start])
        var count = value
        for _ in 0..<(pointsToBeCalc.count){
            if count > constant{
                break
            }
            points.append(precipMid[count])
            probs.append(midProb[count])
            print("premid count 1", precipMid.count)
            count += 66
        }
        
        if precipMid.count < constant2{
            let m = (precipMid.count/61) * 5
            points.append(precipIend[m + start])
            probs.append(endProb[m + start])
        }
        
        print(points)
        print(probs)
        let sum = points.reduce(0, +)
        addedV.append(sum)
        let sum2 = probs.reduce(0, +)
        let sum3 = sum * sum2
        addedP.append(sum3)
    }
    
    func allXAxis2(points: inout [Double], probs: inout [Double], start: Int, constant: Int, constant2: Int, value: Int, addedV: inout [Double], addedP: inout [Double]){
        points.append(precipIstart[start])
        probs.append(startProb[start])
        var count = value
        for _ in 0..<(pointsToBeCalc2.count){
            if count > constant{
                break
            }
            points.append(precipMid2[count])
            probs.append(midProb2[count])
            print("premid count 1", precipMid.count)
            count += 66
        }
        
        if precipMid2.count < constant2{
            let m = (precipMid2.count/61) * 5
            points.append(precipIend[m + start])
            probs.append(endProb[m + start])
        }
        
        print(points)
        print(probs)
        let sum = points.reduce(0, +)
        addedV.append(sum)
        let sum2 = probs.reduce(0, +)
        let sum3 = sum * sum2
        addedP.append(sum3)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if self.precipIstart.count == 61 && self.precipIend.count == 61{ //&& self.precipMid.count >= 61{
            self.addedValues.removeAll()
            self.addedProb.removeAll()
            self.xAxisPoints.removeAll()
            self.xAxisProb.removeAll()
            self.xAxisPoints5.removeAll()
            self.xAxisPoints10.removeAll()
            self.xAxisPoints15.removeAll()
            self.xAxisPoints20.removeAll()
            self.xAxisPoints25.removeAll()
            self.xAxisPoints30.removeAll()
            self.xAxisProb5.removeAll()
            self.xAxisProb10.removeAll()
            self.xAxisProb15.removeAll()
            self.xAxisProb20.removeAll()
            self.xAxisProb25.removeAll()
            self.xAxisProb30.removeAll()
            self.addedValues2.removeAll()
            self.addedProb2.removeAll()
            self.xAxisPoints2.removeAll()
            self.xAxisProb2.removeAll()
            self.xAxisPoints52.removeAll()
            self.xAxisPoints102.removeAll()
            self.xAxisPoints152.removeAll()
            self.xAxisPoints202.removeAll()
            self.xAxisPoints252.removeAll()
            self.xAxisPoints302.removeAll()
            self.xAxisProb52.removeAll()
            self.xAxisProb102.removeAll()
            self.xAxisProb152.removeAll()
            self.xAxisProb202.removeAll()
            self.xAxisProb252.removeAll()
            self.xAxisProb302.removeAll()
            self.allXAxis(points: &xAxisPoints, probs: &xAxisProb, start: 0, constant: 732, constant2: 732, value: 5, addedV: &addedValues, addedP: &addedProb)
            self.allXAxis(points: &xAxisPoints5, probs: &xAxisProb5, start: 5, constant: 670, constant2: 671, value: 10, addedV: &addedValues, addedP: &addedProb)
            self.allXAxis(points: &xAxisPoints10, probs: &xAxisProb10, start: 10, constant: 609, constant2: 610, value: 15, addedV: &addedValues, addedP: &addedProb)
            self.allXAxis(points: &xAxisPoints15, probs: &xAxisProb15, start: 15, constant: 548, constant2: 549, value: 20, addedV: &addedValues, addedP: &addedProb)
            self.allXAxis(points: &xAxisPoints20, probs: &xAxisProb20, start: 20, constant: 487, constant2: 488, value: 25, addedV: &addedValues, addedP: &addedProb)
            self.allXAxis(points: &xAxisPoints25, probs: &xAxisProb25, start: 25, constant: 426, constant2: 427, value: 30, addedV: &addedValues, addedP: &addedProb)
            self.allXAxis(points: &xAxisPoints30, probs: &xAxisProb30, start: 30, constant: 365, constant2: 366, value: 35, addedV: &addedValues, addedP: &addedProb)
            self.allXAxis2(points: &xAxisPoints2, probs: &xAxisProb2, start: 0, constant: 732, constant2: 732, value: 5, addedV: &addedValues2, addedP: &addedProb2)
            self.allXAxis2(points: &xAxisPoints52, probs: &xAxisProb52, start: 5, constant: 670, constant2: 671, value: 10, addedV: &addedValues2, addedP: &addedProb2)
            self.allXAxis2(points: &xAxisPoints102, probs: &xAxisProb102, start: 10, constant: 609, constant2: 610, value: 15, addedV: &addedValues2, addedP: &addedProb2)
            self.allXAxis2(points: &xAxisPoints152, probs: &xAxisProb152, start: 15, constant: 548, constant2: 549, value: 20, addedV: &addedValues2, addedP: &addedProb2)
            self.allXAxis2(points: &xAxisPoints202, probs: &xAxisProb202, start: 20, constant: 487, constant2: 488, value: 25, addedV: &addedValues2, addedP: &addedProb2)
            self.allXAxis2(points: &xAxisPoints252, probs: &xAxisProb252, start: 25, constant: 426, constant2: 427, value: 30, addedV: &addedValues2, addedP: &addedProb2)
            self.allXAxis2(points: &xAxisPoints302, probs: &xAxisProb302, start: 30, constant: 365, constant2: 366, value: 35, addedV: &addedValues2, addedP: &addedProb2)
            
            
            
        }else if segue.identifier == "showSavedSecond" && self.routes == 0{
            let alert = UIAlertController(title: "Error", message: "Problem loading data. Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if segue.identifier == "showSavedSecond" {
            let secondViewController = segue.destination as! SummaryViewController
            secondViewController.distAndDur = dist2
            secondViewController.axisp = xAxisPoints
            secondViewController.axisp2 = xAxisPoints
            secondViewController.axisProb = xAxisProb
            secondViewController.axisProb2 = xAxisProb
            secondViewController.addedIntensity = addedValues
            secondViewController.addedProbability = addedProb
            secondViewController.xaxis5 = xAxisPoints5
            secondViewController.xaxis10 = xAxisPoints10
            secondViewController.xaxis15 = xAxisPoints15
            secondViewController.xaxis20 = xAxisPoints20
            secondViewController.xaxis25 = xAxisPoints25
            secondViewController.xaxis30 = xAxisPoints30
            secondViewController.x5prob = xAxisProb5
            secondViewController.x10prob = xAxisProb10
            secondViewController.x15prob = xAxisProb15
            secondViewController.x20prob = xAxisProb20
            secondViewController.x25prob = xAxisProb25
            secondViewController.x30prob = xAxisProb30
            secondViewController.whichPage = "Second"
            secondViewController.temp = currentTemperatures
            secondViewController.celsius = celsius
            secondViewController.fahrenheit = fahrenheit
        }
            
        else if segue.identifier == "showSavedThird"{
            if self.routes < 2{
                let alert = UIAlertController(title: "Oops!", message: "Only blue route available for the selected journey.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let thirdViewController = segue.destination as! SummaryViewController
                thirdViewController.axisp = xAxisPoints2
                thirdViewController.axisp2 = xAxisPoints2
                thirdViewController.axisProb = xAxisProb2
                thirdViewController.axisProb2 = xAxisProb2
                thirdViewController.addedIntensity = addedValues2
                thirdViewController.addedProbability = addedProb2
                thirdViewController.xaxis5 = xAxisPoints52
                thirdViewController.xaxis10 = xAxisPoints102
                thirdViewController.xaxis15 = xAxisPoints152
                thirdViewController.xaxis20 = xAxisPoints202
                thirdViewController.xaxis25 = xAxisPoints252
                thirdViewController.xaxis30 = xAxisPoints302
                thirdViewController.x5prob = xAxisProb52
                thirdViewController.x10prob = xAxisProb102
                thirdViewController.x15prob = xAxisProb152
                thirdViewController.x20prob = xAxisProb202
                thirdViewController.x25prob = xAxisProb252
                thirdViewController.x30prob = xAxisProb302
                thirdViewController.whichPage = "Third"
                thirdViewController.temp = currentTemperatures
                thirdViewController.celsius = celsius
                thirdViewController.fahrenheit = fahrenheit
            }
        }
        if segue.identifier == "showMap"{
            let mapview = segue.destination as! DisplayContainerViewController
            mapview.delegate = self
        }
        
        
    }
    
    var dist2:String = ""
    
    @IBAction func green(_ sender: UIButton) {
    }
    
    func endWeather(endLocation: CLLocation){
        
        let location = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url = "https://api.darksky.net/forecast/a4c81140857eb4f56994b05a9ba47ef1/\(location)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let minutelyForecasts = json["minutely"] as? [String:Any]{
                            if let minutelyData = minutelyForecasts["data"] as? [[String:Any]]{
                                for dataPoint in minutelyData {
                                    if let pi = dataPoint["precipIntensity"] as? Double{
                                        let pi2 = (pi*25.4)*100
                                        self.precipIend.append(round(pi2)/100)
                                    }
                                    if let prob = dataPoint["precipProbability"] as? Double{
                                        self.endProb.append(prob*100)
                                    }
                                }
                            }
                        }
                        if let currentForecast = json["currently"] as? [String:Any]{
                            if let temperature = currentForecast["temperature"] as? Double{
                                self.currentTemperatures.append(temperature)
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func midWeather(midLocation: CLLocationCoordinate2D){
        let location = "\(midLocation.latitude),\(midLocation.longitude)"
        
        let url = "https://api.darksky.net/forecast/a4c81140857eb4f56994b05a9ba47ef1/\(location)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let minutelyForecasts = json["minutely"] as? [String:Any]{
                            if let minutelyData = minutelyForecasts["data"] as? [[String:Any]]{
                                for dataPoint in minutelyData {
                                    if let pi = dataPoint["precipIntensity"] as? Double{
                                        let pi2 = (pi*25.4)*100
                                        self.precipMid.append(round(pi2)/100)
                                    }
                                    if let prob = dataPoint["precipProbability"] as? Double{
                                        self.midProb.append(prob*100)
                                    }
                                }
                            }
                        }
                        if let currentForecast = json["currently"] as? [String:Any]{
                            if let temperature = currentForecast["temperature"] as? Double{
                                self.currentTemperatures.append(temperature)
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func midWeather2(midLocation: CLLocationCoordinate2D){
        let location = "\(midLocation.latitude),\(midLocation.longitude)"
        
        let url = "https://api.darksky.net/forecast/a4c81140857eb4f56994b05a9ba47ef1/\(location)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let minutelyForecasts = json["minutely"] as? [String:Any]{
                            if let minutelyData = minutelyForecasts["data"] as? [[String:Any]]{
                                for dataPoint in minutelyData {
                                    if let pi = dataPoint["precipIntensity"] as? Double{
                                        let pi2 = (pi*25.4)*100
                                        self.precipMid2.append(round(pi2)/100)
                                    }
                                    if let prob = dataPoint["precipProbability"] as? Double{
                                        self.midProb2.append(prob*100)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    
    func startWeather(startLocation: CLLocation){
        
        let location = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        
        let url = "https://api.darksky.net/forecast/a4c81140857eb4f56994b05a9ba47ef1/\(location)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let minutelyForecasts = json["minutely"] as? [String:Any]{
                            if let minutelyData = minutelyForecasts["data"] as? [[String:Any]]{
                                for dataPoint in minutelyData {
                                    if let pi = dataPoint["precipIntensity"] as? Double{
                                        let pi2 = (pi*25.4)*100
                                        self.precipIstart.append(round(pi2)/100)
                                    }
                                    if let prob = dataPoint["precipProbability"] as? Double{
                                        self.startProb.append(prob*100)
                                    }
                                }
                            }
                        }
                        if let currentForecast = json["currently"] as? [String:Any]{
                            if let temperature = currentForecast["temperature"] as? Double{
                                self.currentTemperatures.append(temperature)
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    
    
    var locationmid = CLLocationCoordinate2D()
    
    
    func middlePoint(startLocation: CLLocation, endLocation: CLLocation){
        let slat = startLocation.coordinate.latitude
        let slon = startLocation.coordinate.longitude
        
        
        let elat = endLocation.coordinate.latitude
        let elon = endLocation.coordinate.longitude
        
        
        let midlat = (slat + elat)/2
        let midlon = (slon + elon)/2
        locationmid = CLLocationCoordinate2DMake(midlat, midlon)
        //self.midWeather(midLocation: locationmid)
        self.endWeather(endLocation: locationEnd)
    }
}



