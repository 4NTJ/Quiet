//
//  NoiseBarChartView.swift
//  Quiet
//
//  Created by Minkyeong Ko on 2022/08/25.
//

import UIKit

import Charts

final class NoiseBarChartView: UIView {
    private var horizontalBarChart = HorizontalBarChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawBarChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBarChart() {
        addSubview(horizontalBarChart)
        
        self.horizontalBarChart.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor,
            trailing: self.trailingAnchor
        )
    }
    
    func setupBarChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in dataPoints.indices {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "소음레벨 평균")

        chartDataSet.colors = [.systemCyan]

        let chartData = BarChartData(dataSet: chartDataSet)
        horizontalBarChart.data = chartData
        
        horizontalBarChart.legend.xEntrySpace = 20
        horizontalBarChart.extraBottomOffset = 15
        horizontalBarChart.legend.font = .systemFont(ofSize: 12)
        
        horizontalBarChart.xAxis.drawGridLinesEnabled = false
        horizontalBarChart.xAxis.labelPosition = .bottom
        horizontalBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        horizontalBarChart.xAxis.granularity = 1.0
        horizontalBarChart.extraLeftOffset = -10
        horizontalBarChart.barData?.barWidth = 0.3
        horizontalBarChart.rightAxis.drawLabelsEnabled = false
        horizontalBarChart.leftAxis.axisMinimum = 0
        horizontalBarChart.leftAxis.axisMaximum = 90
        
        horizontalBarChart.pinchZoomEnabled = false
        horizontalBarChart.doubleTapToZoomEnabled = false
        horizontalBarChart.highlightPerTapEnabled = false
        horizontalBarChart.highlightPerDragEnabled = false
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


