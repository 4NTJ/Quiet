//
//  SearchMapViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/25.
//

import MapKit
import UIKit

final class SearchMapViewController: BaseViewController {
    
    private enum Size {
        static let gulocationBottomConstant: CGFloat = 240
        static let donglocationBottomConstant: CGFloat = 150
    }
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    private let manualButton: UIButton = CircleButton(buttonImage: "info.circle.fill")
    private let locationButton: UIButton = CircleButton(buttonImage: "location")
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        return manager
    }()
    
    private var locationBtnCliked = false {
        didSet {
            let image = locationBtnCliked ? ImageLiteral.icLocationFill : ImageLiteral.icLocation
            locationButton.setImage(image, for: .normal)
        }
    }
    private var locationType: LocationType
    
    // MARK: - Init
    
    init(locationType: LocationType) {
        self.locationType = locationType
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonAction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Func
    
    override func setupLayout() {
        view.addSubview(mapView)
        mapView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                           leading: view.leadingAnchor,
                           bottom: view.safeAreaLayoutGuide.bottomAnchor,
                           trailing: view.trailingAnchor,
                           padding: UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0))
        
        
        mapView.addSubview(manualButton)
        manualButton.constraint(manualButton.widthAnchor,
                                constant: 50)
        manualButton.constraint(manualButton.heightAnchor,
                                constant: 50)
        manualButton.constraint(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: mapView.trailingAnchor,
                                padding: UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: locationType == .dong ? Size.donglocationBottomConstant : Size.gulocationBottomConstant,
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
                                                        bottom: 20,
                                                        right: 20))
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    // MARK: - Func
    
    private func setupButtonAction() {
        manualButton.addTarget(self, action: #selector(manualButtonTapped), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    private func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Selector
    
    @objc
    private func manualButtonTapped() {
        
    }
    
    @objc
    private func locationButtonTapped() {
        mapView.showsUserLocation.toggle()
        mapView.setUserTrackingMode(.follow, animated: true)
        locationBtnCliked.toggle()
    }
}

// MARK: - CLLocationManagerDelegate
extension SearchMapViewController : CLLocationManagerDelegate {
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
