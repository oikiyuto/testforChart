//
//  ViewController.swift
//  testforChart
//
//  Created by yutos on 2019/05/23.
//  Copyright © 2019 yutos. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var chartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        // Do any additional setup after loading the view.
        setChart()
    }


    func setChart(){
        //グラフのサイズ設定、座標設定
        let chart = LineChartView(frame: CGRect(x: 0, y: 20, width: self.chartTableView.frame.width - 20 , height: self.chartTableView.frame.height-20))
        
        chart.data = generateLineData()
        
        //x軸について
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "MM月dd日"
     
        let xaxis = chart.xAxis
        xaxis.avoidFirstLastClippingEnabled = false
        xaxis.granularity = 1.0
        xaxis.labelCount = 4
        
        //chartを出力
        self.chartTableView.addSubview(chart)
    }
    
    
    func generateLineData() -> LineChartData
    {

        let label1 = "label1"
        let values1Nonil:[(Double,Double)] = [(7.482162847222222, 7.4), (6.399996643518518, 6.8), (3.3396863425925924, 7.1), (0.0, 7.4)]
        
        var entries: [ChartDataEntry] = Array()
        for (i, value) in  values1Nonil{
            entries.append(ChartDataEntry(x: i, y: value))
        }
        
        print("chart描画：(x,y) = \(entries)")
        //データを送るためのDataSet変数をリストで作る
        var linedata:  [LineChartDataSet] = Array()
        
        let label2 = "label2"
        let value2:[(Double,Double)] = [(5, 7.4), (6, 6.8),(10, 7.2)]
        
        //values2のxの値が大きすぎると表示されない。これをx = 20程度にすると、この設定でも表示される
        
      
        var entries2: [ChartDataEntry] = Array()
        for (i, value) in  value2{
            entries2.append(ChartDataEntry(x: i, y: value))
        }
        
        let linedataset2 = LineChartDataSet(values: entries2, label: label2)
        linedataset2.colors = [NSUIColor.blue]
        
        linedata.append(linedataset2)
        /*
 
        [ChartDataEntry, x: 748.2162847222222, y 7.4, ChartDataEntry, x: 639.9996643518518, y 6.8, ChartDataEntry, x: 333.96863425925926, y 7.1, ChartDataEntry, x: 0.0, y 7.4]
 */
        //リストにデータを入れるためにデータを成形している
        let lineDataSet1 = LineChartDataSet(values: entries, label: label1)
        lineDataSet1.drawIconsEnabled = true
        //グラフの線の色とマルの色を変えている
        lineDataSet1.colors = [NSUIColor.red]
        lineDataSet1.circleColors = [NSUIColor.red]
        //上で作ったデータをリストにappendで入れる
       linedata.append(lineDataSet1)
        return LineChartData(dataSets: linedata)
    }
}



class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}

extension ChartXAxisFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
            let referenceTimeInterval = referenceTimeInterval
            else {
                return ""
        }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
    
}
