//
//  SummaryViewController.swift
//  Mapping
//
//  Created by Findlay Wood on 05/10/2018.
//  Copyright © 2018 FindlayWood. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func webLink(_ sender: Any) {
        
        if let url = NSURL(string: "https://darksky.net/poweredby/"){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
    }
    
    
    @IBOutlet var nowButton: UIButton!
    @IBOutlet var fiveButton: UIButton!
    @IBOutlet var tenButton: UIButton!
    @IBOutlet var fifteenButton: UIButton!
    @IBOutlet var twentyButton: UIButton!
    @IBOutlet var twentyfiveButton: UIButton!
    @IBOutlet var thirtyButton: UIButton!
    @IBOutlet var temperature:UILabel!
    
    @IBOutlet var tableview: UITableView!
    
    var practiveFigures = ["10", "2", "6", "4"]
    var secondPracticeFigures = ["1", "0", "12"]
    var fiveTimes = ["0", "5", "10"]
    var joureyMinutes = ["0", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
    var test = String()
    
    
    var distAndDur:String = ""
    var axisp = [Double]()
    var axisp2 = [Double]()
    var axisProb = [Double]()
    var axisProb2 = [Double]()
    var addedIntensity = [Double]()
    var addedProbability = [Double]()
    var xaxis5 = [Double]()
    var xaxis10 = [Double]()
    var xaxis15 = [Double]()
    var xaxis20 = [Double]()
    var xaxis25 = [Double]()
    var xaxis30 = [Double]()
    var x5prob = [Double]()
    var x10prob = [Double]()
    var x15prob = [Double]()
    var x20prob = [Double]()
    var x25prob = [Double]()
    var x30prob = [Double]()
    
    var whichPage: String!
    
    var temp = [Double]()
    var celsius: String!
    var fahrenheit: String!
    
    @IBAction func nowPressed(_ sender:UIButton){
        nowButton.isSelected = true
        fiveButton.isSelected = false
        tenButton.isSelected = false
        fifteenButton.isSelected = false
        twentyButton.isSelected = false
        twentyfiveButton.isSelected = false
        thirtyButton.isSelected = false
        tableview.reloadData()
    }
    
    @IBAction func fivePressed(_ sender:UIButton){
        nowButton.isSelected = false
        fiveButton.isSelected = true
        tenButton.isSelected = false
        fifteenButton.isSelected = false
        twentyButton.isSelected = false
        twentyfiveButton.isSelected = false
        thirtyButton.isSelected = false
        tableview.reloadData()
    }
    
    @IBAction func tenPressed(_ sender:UIButton){
        nowButton.isSelected = false
        fiveButton.isSelected = false
        tenButton.isSelected = true
        fifteenButton.isSelected = false
        twentyButton.isSelected = false
        twentyfiveButton.isSelected = false
        thirtyButton.isSelected = false
        tableview.reloadData()
    }
    
    @IBAction func fifteenPressed(_ sender:UIButton){
        nowButton.isSelected = false
        fiveButton.isSelected = false
        tenButton.isSelected = false
        fifteenButton.isSelected = true
        twentyButton.isSelected = false
        twentyfiveButton.isSelected = false
        thirtyButton.isSelected = false
        tableview.reloadData()
    }
    @IBAction func twentyPressed(_ sender:UIButton){
        nowButton.isSelected = false
        fiveButton.isSelected = false
        tenButton.isSelected = false
        fifteenButton.isSelected = false
        twentyButton.isSelected = true
        twentyfiveButton.isSelected = false
        thirtyButton.isSelected = false
        tableview.reloadData()
    }
    
    @IBAction func twentyFivePressed(_ sender:UIButton){
        nowButton.isSelected = false
        fiveButton.isSelected = false
        tenButton.isSelected = false
        fifteenButton.isSelected = false
        twentyButton.isSelected = false
        twentyfiveButton.isSelected = true
        thirtyButton.isSelected = false
        tableview.reloadData()
    }
    @IBAction func thirtyPressed(_ sender:UIButton){
        nowButton.isSelected = false
        fiveButton.isSelected = false
        tenButton.isSelected = false
        fifteenButton.isSelected = false
        twentyButton.isSelected = false
        twentyfiveButton.isSelected = false
        thirtyButton.isSelected = true
        tableview.reloadData()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nowButton.isSelected{
            return axisp.count
        }
        if fiveButton.isSelected{
            return xaxis5.count
        }
        if tenButton.isSelected{
            return xaxis10.count
        }
        if fifteenButton.isSelected{
            return xaxis15.count
        }
        if twentyButton.isSelected{
            return xaxis20.count
        }
        if twentyfiveButton.isSelected{
            return xaxis25.count
        }
        if thirtyButton.isSelected{
            return xaxis30.count
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SummaryTableViewCell
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if nowButton.isSelected{
            if axisp[indexPath.row] == 0{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Clear"
                cell.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
            }else if axisp[indexPath.row] < 2.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Light Rain"
                cell.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
            }else if axisp[indexPath.row] < 7.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Moderate Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            }else{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Heavy Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            
        }
        if fiveButton.isSelected{
            if xaxis5[indexPath.row] == 0{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Clear"
                cell.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
            }else if xaxis5[indexPath.row] < 2.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Light Rain"
                cell.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
            }else if xaxis5[indexPath.row] < 7.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Moderate Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            }else{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Heavy Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }
        
        if tenButton.isSelected{
            if xaxis10[indexPath.row] == 0{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Clear"
                cell.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
            }else if xaxis10[indexPath.row] < 2.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Light Rain"
                cell.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
            }else if xaxis10[indexPath.row] < 7.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Moderate Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            }else{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Heavy Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }
        
        if fifteenButton.isSelected{
            if xaxis15[indexPath.row] == 0{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Clear"
                cell.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
            }else if xaxis15[indexPath.row] < 2.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Light Rain"
                cell.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
            }else if xaxis15[indexPath.row] < 7.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Moderate Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            }else{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Heavy Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }
        
        if twentyButton.isSelected{
            if xaxis20[indexPath.row] == 0{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Clear"
                cell.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
            }else if xaxis20[indexPath.row] < 2.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Light Rain"
                cell.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
            }else if xaxis20[indexPath.row] < 7.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Moderate Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            }else{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Heavy Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }
        
        if twentyfiveButton.isSelected{
            if xaxis25[indexPath.row] == 0{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Clear"
                cell.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
            }else if xaxis25[indexPath.row] < 2.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Light Rain"
                cell.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
            }else if xaxis25[indexPath.row] < 7.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Moderate Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            }else{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Heavy Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }
        
        if thirtyButton.isSelected{
            if xaxis30[indexPath.row] == 0{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Clear"
                cell.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
            }else if xaxis30[indexPath.row] < 2.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Light Rain"
                cell.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
            }else if xaxis30[indexPath.row] < 7.5{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Moderate Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            }else{
                cell.minuteLabel.text = "\(joureyMinutes[indexPath.row]) mins"
                cell.intensityLabel.text = "Heavy Rain"
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
        }
        
        
        
        
        return cell
    }
    
    @IBAction func detailedView(_ sender: UIBarButtonItem){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if whichPage == "Second"{
            let secondViewController = storyBoard.instantiateViewController(withIdentifier: "second") as! SecondViewController
            secondViewController.distAndDur = distAndDur
            secondViewController.axisp = axisp
            secondViewController.axisp2 = axisp2
            secondViewController.axisProb = axisProb
            secondViewController.axisProb2 = axisProb2
            secondViewController.addedIntensity = addedIntensity
            secondViewController.addedProbability = addedProbability
            secondViewController.xaxis5 = xaxis5
            secondViewController.xaxis10 = xaxis10
            secondViewController.xaxis15 = xaxis15
            secondViewController.xaxis20 = xaxis20
            secondViewController.xaxis25 = xaxis25
            secondViewController.xaxis30 = xaxis30
            secondViewController.x5prob = x5prob
            secondViewController.x10prob = x10prob
            secondViewController.x15prob = x15prob
            secondViewController.x20prob = x20prob
            secondViewController.x25prob = x25prob
            secondViewController.x30prob = x30prob
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else{
            let secondViewController = storyBoard.instantiateViewController(withIdentifier: "third") as! ThirdViewController
            secondViewController.distAndDur = distAndDur
            secondViewController.axisp = axisp
            secondViewController.axisp2 = axisp2
            secondViewController.axisProb = axisProb
            secondViewController.axisProb2 = axisProb2
            secondViewController.addedIntensity = addedIntensity
            secondViewController.addedProbability = addedProbability
            secondViewController.xaxis5 = xaxis5
            secondViewController.xaxis10 = xaxis10
            secondViewController.xaxis15 = xaxis15
            secondViewController.xaxis20 = xaxis20
            secondViewController.xaxis25 = xaxis25
            secondViewController.xaxis30 = xaxis30
            secondViewController.x5prob = x5prob
            secondViewController.x10prob = x10prob
            secondViewController.x15prob = x15prob
            secondViewController.x20prob = x20prob
            secondViewController.x25prob = x25prob
            secondViewController.x30prob = x30prob
            self.navigationController?.pushViewController(secondViewController, animated: true)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nowButton.isSelected = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Detailed View", style: .plain, target: self, action: #selector(detailedView(_:)))
        let sum = temp.reduce(0,+)
        let average = sum/Double(temp.count)
        let first = Int(average)
        let second = 0.55
        let cel = Double(first-32) * second
        let view = String(format: "%.0f", cel)
        self.temperature.text = "\(view)°C"
        

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func switchTemperature(_ sender:Any){
        if (temperature.text?.contains("F"))!{
            let sum = temp.reduce(0,+)
            let average = sum/Double(temp.count)
            let first = Int(average)
            let second = 0.55
            let cel = Double(first-32) * second
            let view = String(format: "%.0f", cel)
            self.temperature.text = "\(view)°C"
        }else{
            let sum = temp.reduce(0,+)
            let average = sum/Double(temp.count)
            self.temperature.text = "\(String(Int(average)) as String)°F"
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
