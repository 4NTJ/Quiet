//
//  NoiseLineChartView.swift
//  Quiet
//
//  Created by Minkyeong Ko on 2022/08/25.
//

import UIKit

import Charts

final class NoiseLineChartView: UIView {
    private var lineChart: LineChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawLineChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLineChart() {
        lineChart = LineChartView()
        addSubview(lineChart)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.constraint(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
    
    func setupLineChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "시간별 데시벨 정보")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        lineChart.noDataText = "데이터가 없습니다"
        lineChart.noDataFont = .systemFont(ofSize: 20)
        lineChart.noDataTextColor = .lightGray
        
        let limitLine = ChartLimitLine(limit: 120, label: "한도")
        lineChart.rightAxis.addLimitLine(limitLine)
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        lineChart.xAxis.setLabelCount(dataPoints.count, force: false)
        lineChart.data = lineChartData
        
        lineChartDataSet.colors = [UIColor.blue]
        lineChartDataSet.circleRadius = 3
        
        lineChart.animate(xAxisDuration: 3.0, easingOption: .easeInOutBack)
    }
    
    func setupAverageLineChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[dataPoints.count-1-i]/2)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "서울시 평균")
        lineChart.data?.addDataSet(lineChartDataSet)
        
        lineChartDataSet.colors = [UIColor.gray]
        lineChartDataSet.circleRadius = 0.5
        lineChartDataSet.drawValuesEnabled = false
        lineChart.animate(xAxisDuration: 3.0, easingOption: .easeInOutBack)
    }
}

