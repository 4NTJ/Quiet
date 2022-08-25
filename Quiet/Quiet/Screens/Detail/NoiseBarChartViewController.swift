//
//  NoiseBarChartViewController.swift
//  Quiet
//
//  Created by Minkyeong Ko on 2022/08/25.
//

import UIKit

import Charts

class NoiseBarChartViewController: UIViewController {
    var barChartView: NoiseBarChartView!
    
    let months = ["주중", "주말"]
    let dbValues: [Double] = [68, 54]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarChartView()
    }
    
    private func setupBarChartView() {
        self.barChartView = NoiseBarChartView()
        self.barChartView.setupBarChart(dataPoints: months, values: dbValues)
        self.view.addSubview(self.barChartView)
        self.barChartView.constraint(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.centerYAnchor,
            trailing: self.view.trailingAnchor
        )
    }
}

#if DEBUG
import SwiftUI
struct NoiseBarChartViewController_Previews: PreviewProvider {
    static var previews: some View {
        NoiseBarChartViewController().toPreview().previewInterfaceOrientation(.portrait)
    }
}
#endif

