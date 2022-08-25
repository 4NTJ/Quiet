//
//  NoiseLineChartViewController.swift
//  Quiet
//
//  Created by Minkyeong Ko on 2022/08/25.
//

import UIKit

import Charts

class NoiseLineChartViewController: UIViewController {
    var lineChartView: NoiseLineChartView!
    
    let hours: [String] = (0...24).map{ num in
        String(num)
    }
    let dbValues: [Double] = [68, 54, 56, 70, 80, 46, 55, 60, 64, 50, 55, 56, 68, 54, 56, 70, 80, 46, 55, 60, 64, 50, 55, 56, 68]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLineChartView()
    }
    
    private func setupLineChartView() {
        self.lineChartView = NoiseLineChartView()
        self.lineChartView.setupLineChart(dataPoints: hours, values: dbValues)
        self.lineChartView.setupAverageLineChart(dataPoints: hours, values: dbValues)
        self.view.addSubview(self.lineChartView)
        self.lineChartView.constraint(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.centerYAnchor,
            trailing: self.view.trailingAnchor
        )
    }
}

#if DEBUG
import SwiftUI
struct NoiseLineChartViewController_Preview: PreviewProvider {
    static var previews: some View {
        NoiseLineChartViewController().toPreview().previewInterfaceOrientation(.portrait)
    }
}
#endif

