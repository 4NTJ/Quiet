//
//  NoiseBarChartView.swift
//  Quiet
//
//  Created by Minkyeong Ko on 2022/08/25.
//

import UIKit

import Charts

final class NoiseBarChartView: UIView {
    private var horizontalBarChart: HorizontalBarChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawBarChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBarChart() {
        horizontalBarChart = HorizontalBarChartView()
        addSubview(horizontalBarChart)
        
        horizontalBarChart.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalBarChart.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor
        )
    }
    
    func setupBarChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "데시벨 정보")

        chartDataSet.colors = [.systemBlue]

        let chartData = BarChartData(dataSet: chartDataSet)
        horizontalBarChart.data = chartData
    }
}

#if DEBUG
import SwiftUI
struct NoiseBarChartView_Preview: PreviewProvider {
    static var previews: some View {
        NoiseBarChartView().toPreview()
    }
}
#endif


