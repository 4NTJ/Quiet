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
    
    private var locationBtnCliked = true {
        didSet {
            let image = locationBtnCliked ?  ImageLiteral.icLocationFill
                .resize(to: CGSize(width: 25, height: 25)) :
            ImageLiteral.icLocation
                .resize(to: CGSize(width: 25, height: 25))
            locationButton.setImage(image, for: .normal)
        }
    }
    
    private let searchBarView = SearchBarView()
    
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
    
    private let manualButton: UIButton = CircleButton(buttonImage: "info.circle.fill")
    private let locationButton: UIButton = CircleButton(buttonImage: "location.fill")
    
    
    
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationUsagePermission()
        setDelegation()
        setupLayout()
        btnAddTargets()
        setMapRegion()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - Func
    
    
    private func setDelegation() {
        locationManager.delegate = self
        searchBarView.delegate = self
    }
    
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
        manualButton.constraint(bottom: view.safeAreaLayoutGuide.bottomAnchor,
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
        let vc = ManualViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func locationButtonTapped() {
        mapView.showsUserLocation.toggle()
        locationBtnCliked.toggle()
        if mapView.showsUserLocation {
            mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            mapView.setUserTrackingMode(.none, animated: true)

        }
    }
    
    private func setMapRegion() {
        guard let locationCoorinate = locationManager.location?.coordinate else {return}
            let region = MKCoordinateRegion(center: locationCoorinate, span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.016) )
        mapView.setRegion(region, animated: true)
    }
}


// MARK: - CLLocationManagerDelegate
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


// MARK: - SearchTappedDelegate
extension MapViewController: SearchTappedDelegate {
    func tapSearch() {
        guard let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchNavController") as? UINavigationController else {return}
        searchVC.modalPresentationStyle = .fullScreen
        searchVC.modalTransitionStyle = .crossDissolve
        present(searchVC, animated: true)
    }
    
    
}
