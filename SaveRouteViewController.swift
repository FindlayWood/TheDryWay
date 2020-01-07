//
//  SaveRouteViewController.swift
//  Mapping
//
//  Created by Findlay Wood on 23/09/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreData

class SaveRouteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var routes = [String]()
    var saved = [NSManagedObject]()
    @IBOutlet var tableview: UITableView!
    
    
    
    
    
    @IBAction func addPressed(_ sender: UIButton){
        
        
    }
    
    func queryData(){
        routes.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedRoutes")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            self.saved = result as! [NSManagedObject]
            for data in result as! [NSManagedObject] {
                routes.append(data.value(forKey: "name") as! String)
                print(data.value(forKey: "name") as! String)
                tableview.reloadData()
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        queryData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //queryData()
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saved.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        //cell.textLabel?.text = routes[indexPath.row]
        cell.textLabel?.text = saved[indexPath.row].value(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tabBarController?.selectedIndex = 0
        let startlon = saved[indexPath.row].value(forKey: "startlong") as! Double
        let startlat = saved[indexPath.row].value(forKey: "startlat") as! Double
        let endlon = saved[indexPath.row].value(forKey: "endlong") as! Double
        let endlat = saved[indexPath.row].value(forKey: "endlat") as! Double
        //let startPoint = CLLocationCoordinate2DMake(startlat, startlon)
        //let endPoint = CLLocationCoordinate2DMake(endlat, endlon)
        print("\(saved[indexPath.row].value(forKey: "name") as! String) = \(startlat), \(startlon)")
        
        
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let SVC = StoryBoard.instantiateViewController(withIdentifier: "DisplaySaved") as! DisplaySavedViewController
        
        let name = saved[indexPath.row].value(forKey: "name") as! String
        let startname = saved[indexPath.row].value(forKey: "startname") as! String
        let endname = saved[indexPath.row].value(forKey: "endname") as! String
        print(name)
        
        SVC.startText = startname
        SVC.endText = endname
        SVC.name = name
        SVC.locationStart = CLLocation(latitude: startlat, longitude: startlon)
        SVC.locationEnd = CLLocation(latitude: endlat, longitude: endlon)
        
        self.navigationController?.pushViewController(SVC, animated: true)
    }
    
    func deleteRecord(at indexPath: IndexPath){
        let record = saved[indexPath.row]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(record)
        self.saved.remove(at: indexPath.row)
        self.tableview.deleteRows(at: [indexPath], with: .automatic)
        
        do{
            try context.save()
        }catch{
            print("Failed delete")
            let alert = UIAlertController(title: "Error", message: "Failed to delete route. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteRecord(at: indexPath)
        }
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


