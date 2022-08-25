//
//  SearchMapViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/25.
//

import MapKit
import UIKit

final class SearchMapViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    
    // MARK: - Func
    
    override func setupLayout() {
        view.addSubview(mapView)
        mapView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                           leading: view.leadingAnchor,
                           bottom: view.safeAreaLayoutGuide.bottomAnchor,
                           trailing: view.trailingAnchor,
                           padding: UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0))
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
