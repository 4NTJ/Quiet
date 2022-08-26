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
        
        lineChart.noDataText = NSLocalizedString("Loading...", comment: "Loading...")
        lineChart.noDataFont = .systemFont(ofSize: 20)
        lineChart.noDataTextColor = .lightGray
        
        addSubview(lineChart)
        
        lineChart.constraint(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
    
    func setupLineChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in dataPoints.indices {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "시간별 소음레벨")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        let limitLine = ChartLimitLine(limit: 120, label: "한도")
        lineChart.rightAxis.addLimitLine(limitLine)
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        lineChart.xAxis.setLabelCount(dataPoints.count/3, force: false)
        lineChart.data = lineChartData
        
        lineChart.chartDescription?.enabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        
        lineChart.legend.xEntrySpace = 20
        lineChart.extraBottomOffset = 15
        lineChart.legend.font = .systemFont(ofSize: 12)
        lineChart.data?.setDrawValues(false)
        
        lineChartDataSet.colors = [UIColor.systemCyan]
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.highlightColor = .gray
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.lineWidth = 2
        lineChartDataSet.lineCapType = .round
        
        lineChart.animate(xAxisDuration: 3.0, easingOption: .easeInOutBack)
    }
    
    func setupAverageLineChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in dataPoints.indices {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[dataPoints.count-1-i]/2)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "서울시 평균")
        lineChart.data?.addDataSet(lineChartDataSet)
        
        let marker = ChartMarker()
        marker.chartView = lineChart
        lineChart.marker = marker
        
        lineChartDataSet.colors = [UIColor.gray]
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.highlightColor = .gray
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        
        lineChart.animate(xAxisDuration: 3.0, easingOption: .easeInOutBack)
        lineChart.pinchZoomEnabled = false
        lineChart.doubleTapToZoomEnabled = false
    }
}

class ChartMarker: MarkerView {
    private var text = String()

    private let drawAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 10),
        .foregroundColor: UIColor.black
    ]

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        text = String(entry.y)
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)

        let sizeForDrawing = text.size(withAttributes: drawAttributes)
        bounds.size = sizeForDrawing
        offset = CGPoint(x: -sizeForDrawing.width / 2, y: -sizeForDrawing.height - 4)

        let offset = offsetForDrawing(atPoint: point)
        let originPoint = CGPoint(x: point.x + offset.x, y: point.y + offset.y)
        let rectForText = CGRect(origin: originPoint, size: sizeForDrawing)
        drawText(text: text, rect: rectForText, withAttributes: drawAttributes)
    }

    private func drawText(text: String, rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]? = nil) {
        let size = bounds.size
        let centeredRect = CGRect(
            x: rect.origin.x + (rect.size.width - size.width) / 2,
            y: rect.origin.y + (rect.size.height - size.height) / 2,
            width: size.width,
            height: size.height
        )
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}
