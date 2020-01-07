//
//  SecondViewController.swift
//  Mapping
//
//  Created by Findlay Wood on 27/11/2017.
//  Copyright © 2017 FindlayWood. All rights reserved.
//

import UIKit
import Charts


class SecondViewController: UIViewController {
    
    @IBOutlet var barChartView: BarChartView!
    @IBOutlet var distanceAndDuration: UILabel!
    @IBOutlet var barChartView2: BarChartView!
    @IBOutlet var barchartView3: BarChartView!
    @IBOutlet var firstLabel: UILabel!
    
    @IBAction func webLink(_ sender: Any) {
        
        if let url = NSURL(string: "https://darksky.net/poweredby/"){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
    }
    
    
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
    
    
     /*var axisp = [5.0, 3.0, 2.0, 3.0]
     var axisp2 = [5.0, 3.0, 2.0, 3.0]
     var axisProb = [100.0, 100.0, 100.0, 100.0]
     var axisProb2 = [100.0, 100.0, 100.0, 100.0]
     var addedIntensity = [500.0, 200.0, 300.0, 200.0, 500.0, 100.0, 600.0]
     var addedProbability = [400.0, 200.0, 300.0, 200.0, 450.0, 100.0, 600.0]
     var xaxis5 = [3.0, 2.0, 2.0, 3.0]
     var xaxis10 = [2.0, 8.0, 2.0, 3.0]
     var xaxis15 = [2.0, 1.0, 2.0, 7.0]
     var xaxis20 = [5.0, 3.0, 5.0, 3.0]
     var xaxis25 = [1.0, 1.0, 2.0, 1.0]
     var xaxis30 = [8.0, 2.0, 2.0, 3.0]
     var x5prob = [100.0, 100.0, 100.0, 100.0]
     var x10prob = [100.0, 100.0, 100.0, 100.0]
     var x15prob = [100.0, 100.0, 100.0, 100.0]
     var x20prob = [100.0, 100.0, 100.0, 100.0]
     var x25prob = [100.0, 100.0, 100.0, 100.0]
     var x30prob = [100.0, 100.0, 100.0, 100.0]*/
 
    

    let minutes = ["0", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
    let leaveTimes = ["Now", "5", "10", "15", "20", "25", "30"]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    @IBAction func summaryPage(_ sender: UIBarButtonItem){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "summary") as! SummaryViewController
        //self.present(nextViewController, animated:true, completion:nil)
        nextViewController.axisp = self.axisp
        nextViewController.xaxis5 = self.xaxis5
        nextViewController.xaxis10 = self.xaxis10
        nextViewController.xaxis15 = self.xaxis15
        nextViewController.xaxis20 = self.xaxis20
        nextViewController.xaxis25 = self.xaxis25
        nextViewController.xaxis30 = self.xaxis30
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        barChartView.doubleTapToZoomEnabled = false
        barChartView2.doubleTapToZoomEnabled = false
        barchartView3.doubleTapToZoomEnabled = false
        
        
        self.navigationController?.navigationBar.isHidden = false
        //self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        //self.navigationItem.title = "\(distAndDur)"
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Summary", style: .plain, target: self, action: #selector(summaryPage(_:)))
        
        // Do any additional setup after loading the view, typically from a nib.
        barChartView2.delegate = self as? ChartViewDelegate
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.chartDescription?.text = ""
        barChartView2.chartDescription?.text = ""
        barchartView3.chartDescription?.text = ""
        
        
        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 40.0;
        legend.yEntrySpace = 0.0;
        
        //legend2
        let legend2 = barChartView2.legend
        legend2.enabled = true
        legend2.horizontalAlignment = .left
        legend2.verticalAlignment = .top
        legend2.orientation = .vertical
        legend2.drawInside = true
        legend2.yOffset = 10.0;
        legend2.xOffset = 40.0;
        legend2.yEntrySpace = 0.0;
        
        //legend3
        let legend3 = barchartView3.legend
        legend3.enabled = true
        legend3.horizontalAlignment = .left
        legend3.verticalAlignment = .top
        legend3.orientation = .vertical
        legend3.drawInside = true
        legend3.yOffset = 10.0;
        legend3.xOffset = 30.0;
        legend3.yEntrySpace = 0.0;
        
        
        
        let xaxis = barChartView.xAxis
        //xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = false
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.minutes)
        xaxis.granularity = 1
        
        
        //xaxis2
        let xaxis2 = barChartView2.xAxis
        xaxis2.drawGridLinesEnabled = false
        xaxis2.labelPosition = .bottom
        xaxis2.centerAxisLabelsEnabled = false
        xaxis2.valueFormatter = IndexAxisValueFormatter(values:self.leaveTimes)
        xaxis2.granularity = 1
        
        //xaxis3
        let xaxis3 = barchartView3.xAxis
        xaxis3.drawGridLinesEnabled = false
        xaxis3.labelPosition = .bottom
        xaxis3.centerAxisLabelsEnabled = false
        xaxis3.valueFormatter = IndexAxisValueFormatter(values:self.minutes)
        xaxis3.granularity = 1
        
    
        
        
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        yaxis.axisMaximum = 130
        yaxis.drawTopYLabelEntryEnabled = false
        
        
        
        //yaxis2
        let yaxis2 = barChartView2.leftAxis
        yaxis2.spaceTop = 0.35
        yaxis2.axisMinimum = 0
        yaxis2.drawGridLinesEnabled = false
        if addedProbability.count == 0{
            yaxis2.axisMaximum = 5000
        }
        else{
            yaxis2.axisMaximum = addedProbability.max()! + 500
        }
        
        
        var maxIntensity = [Double]()
        
        if axisp.count > 0 {
            for x in axisp{
                maxIntensity.append(x)
            }
            for x in xaxis10{
                maxIntensity.append(x)
            }
            for x in xaxis20{
                maxIntensity.append(x)
            }
        }
        
        //yaxis3
        let yaxis3 = barchartView3.leftAxis
        yaxis3.spaceTop = 0.35
        yaxis3.axisMinimum = 0
        yaxis3.drawGridLinesEnabled = false
        if maxIntensity.count == 0{
            yaxis3.axisMaximum = 1
        }
        else{
            yaxis3.axisMaximum = maxIntensity.max()! + 0.5
        }
        
        barChartView.rightAxis.enabled = false
        barChartView2.rightAxis.enabled = false
        barchartView3.rightAxis.enabled = false
        //axisFormatDelegate = self
        
        var prob100 = [Double]()
        for x in axisProb{
            let a = x * 100
            prob100.append(a)
            
        }
        setChart3(values: axisProb)
        setChart(values: addedProbability)
        setChart2(values: axisp)
        
    }
    
    
    func setChart3(values: [Double]) {
        barChartView.noDataText = "You need to select a journey to get data."
        //let firstLegend = LegendEntry.init(label: "Probability (%)", form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor.red)
        
        let chartData = BarChartDataSet()
        for (i, val) in values.enumerated(){
            _ = chartData.addEntry(BarChartDataEntry(x: Double(i), y: val))
        }
        barChartView.data = BarChartData(dataSet: chartData)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        //barChartView.legend.entries = [firstLegend]
        barChartView.legend.enabled = false
        chartData.colors = [UIColor.red]
        chartData.valueTextColor = UIColor.clear
        chartData.highlightEnabled = false
        
    }

    func setChart(values: [Double]) {
        barChartView2.noDataText = "You need to select a journey to get data."
        //let firstLegend = LegendEntry.init(label: "Total Intensity * Total Probability", form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor.green)
        
        
        let chartData = BarChartDataSet()
        for (i, val) in values.enumerated(){
            _ = chartData.addEntry(BarChartDataEntry(x: Double(i), y: val))
        }
        barChartView2.data = BarChartData(dataSet: chartData)
        barChartView2.xAxis.labelPosition = .bottom
        barChartView2.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        //barChartView2.legend.entries = [firstLegend]
        barChartView2.legend.enabled = false
        chartData.valueTextColor = UIColor.clear
        chartData.colors = [UIColor.green]
        
        
        
        
    }
    func setChart2(values: [Double]){
        barchartView3.noDataText = "You need to select a journey to get data."
        //let firstLegend = LegendEntry.init(label: "Intensity (mm per hour)", form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: UIColor.blue)
        
        let chartData = BarChartDataSet()
        for (i, val) in values.enumerated(){
            _ = chartData.addEntry(BarChartDataEntry(x: Double(i), y: val))
        }
        barchartView3.data = BarChartData(dataSet: chartData)
        barchartView3.xAxis.labelPosition = .bottom
        barchartView3.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        //barchartView3.legend.entries = [firstLegend]
        barchartView3.legend.enabled = false
        chartData.valueTextColor = UIColor.clear
        chartData.colors = [UIColor.blue]
        chartData.highlightEnabled = false
        
        
        
    }
    
    func setColor(value: Double) -> UIColor{
        
        if(value < 30){
            return UIColor.red
        }
        else if(value <= 70 && value >= 30){
            return UIColor.orange
        }
        else if(value > 70){
            return UIColor.green
        }
            
        else { //In case anything goes wrong
            return UIColor.black
        }
    }
    
    
    
}
extension SecondViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return minutes[ Int(value) % leaveTimes.count]
    }
}
    
    
    // MARK: - ChartViewDelegate
    extension SecondViewController: ChartViewDelegate{
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            if entry.x == 0.0{
                print("bar 1")
                firstLabel.text = "Total rain expected along the whole journey. Leave now selected."
                axisp.removeAll()
                axisProb.removeAll()
                for i in axisp2{
                    axisp.append(i)
                }
                for i in axisProb2{
                    axisProb.append(i)
                }
                setChart3(values: axisProb)
                setChart2(values: axisp)
            }
            if entry.x == 1.0{
                print("bar 2")
                firstLabel.text = "Total rain expected along the whole journey. Leave in 5 mins selected."
                axisp.removeAll()
                axisProb.removeAll()
                for i in xaxis5{
                    axisp.append(i)
                }
                for i in x5prob{
                    axisProb.append(i)
                }
                setChart3(values: axisProb)
                setChart2(values: axisp)
            }
            if entry.x == 2.0{
                print("bar 3")
                firstLabel.text = "Total rain expected along the whole journey. Leave in 10 mins selected."
                axisp.removeAll()
                axisProb.removeAll()
                for i in xaxis10{
                    axisp.append(i)
                }
                for i in x10prob{
                    axisProb.append(i)
                }
                setChart3(values: axisProb)
                setChart2(values: axisp)
            }
            if entry.x == 3.0{
                print("bar 3")
                firstLabel.text = "Total rain expected along the whole journey. Leave in 15 mins selected."
                axisp.removeAll()
                axisProb.removeAll()
                for i in xaxis15{
                    axisp.append(i)
                }
                for i in x15prob{
                    axisProb.append(i)
                }
                setChart3(values: axisProb)
                setChart2(values: axisp)
            }
            if entry.x == 4.0{
                print("bar 3")
                firstLabel.text = "Total rain expected along the whole journey. Leave in 20 mins selected."
                axisp.removeAll()
                axisProb.removeAll()
                for i in xaxis20{
                    axisp.append(i)
                }
                for i in x20prob{
                    axisProb.append(i)
                }
                setChart3(values: axisProb)
                setChart2(values: axisp)
            }
            if entry.x == 5.0{
                print("bar 3")
                firstLabel.text = "Total rain expected along the whole journey. Leave in 25 mins selected."
                axisp.removeAll()
                axisProb.removeAll()
                for i in xaxis25{
                    axisp.append(i)
                }
                for i in x25prob{
                    axisProb.append(i)
                }
                setChart3(values: axisProb)
                setChart2(values: axisp)
            }
            if entry.x == 6.0{
                print("bar 3")
                firstLabel.text = "Total rain expected along the whole journey. Leave in 30 mins selected."
                axisp.removeAll()
                axisProb.removeAll()
                for i in xaxis30{
                    axisp.append(i)
                }
                for i in x30prob{
                    axisProb.append(i)
                }
                setChart3(values: axisProb)
                setChart2(values: axisp)
            }
    
        }
    }
    

