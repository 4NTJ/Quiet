//
//  MapViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import MapKit
import UIKit

class MapViewController: UIViewController {
    // MARK: - Properties
    
    
    private let searchBarView: SearchBarView = {
        let view = SearchBarView()
        return view
    }()
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        view.mapType = MKMapType.standard
        view.showsUserLocation = true
        view.setUserTrackingMode(.follow, animated: true)
        view.isZoomEnabled = true
        return view
    }()
    
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        return manager
    }()
    
    
    private let manualButton: UIButton = {
        let button = CircleButton(buttonImage: "info.circle.fill")
        return button
    }()
    
    private let locationButton: UIButton = {
        let button = CircleButton(buttonImage: "location")
        return button
    }()
    
    
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationUsagePermission()
        locationManager.delegate = self
        
        setupLayout()
        btnAddTargets()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - Func
    
    
    private func setupLayout() {
        view.addSubview(mapView)
        mapView.constraint(to: view)
        
        
        mapView.addSubview(searchBarView)
        searchBarView.constraint(searchBarView.widthAnchor, constant: 350)
        searchBarView.constraint(searchBarView.heightAnchor, constant: 60)
        searchBarView.constraint(top: view.topAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 60,
                                                       left: 20,
                                                       bottom: 0,
                                                       right: 20))
        
        
        mapView.addSubview(manualButton)
        manualButton.constraint(manualButton.widthAnchor,
                                constant: 50)
        manualButton.constraint(manualButton.heightAnchor,
                                constant: 50)
        manualButton.constraint(bottom: mapView.bottomAnchor,
                                trailing: mapView.trailingAnchor,
                                padding: UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: 20,
                                                      right: 20))
        
        mapView.addSubview(locationButton)
        locationButton.constraint(locationButton.widthAnchor,
                                  constant: 50)
        locationButton.constraint(locationButton.heightAnchor,
                                  constant: 50)
        locationButton.constraint(bottom: manualButton.topAnchor,
                                  trailing: mapView.trailingAnchor,
                                  padding: UIEdgeInsets(top: 0,
                                                        left: 0,
                                                        bottom: 16,
                                                        right: 20))
    }
    
    private func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func btnAddTargets() {
        manualButton.addTarget(self, action: #selector(manualButtonTapped), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    @objc private func manualButtonTapped() {
    }
    
    @objc private func locationButtonTapped() {
    }
    
}


// MARK: - Extension


extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            DispatchQueue.main.async {
                self.getLocationUsagePermission()
            }
        case .denied:
            print("GPS 권한 요청 거부됨")
            DispatchQueue.main.async {
                self.getLocationUsagePermission()
            }
        default:
            print("GPS: Default")
        }
    }
}


