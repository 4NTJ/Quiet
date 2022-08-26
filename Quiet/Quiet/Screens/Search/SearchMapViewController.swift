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
    private var locationData: [InstallInfo]
    
    // MARK: - Init
    
    init(locationType: LocationType, locationData: [InstallInfo]) {
        self.locationType = locationType
        self.locationData = locationData
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setAnnotation()
        moveLocation()
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
    
    private func setupMapView() {
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationView.className)
        mapView.delegate = self
    }
    
    private func setAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
        
        locationData.forEach {
            let annotation = MKPointAnnotation()
            guard let latitude = Double($0.latitude ?? "0"),
                  let longitude = Double($0.longitude ?? "0") else { return }
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            mapView.addAnnotation(annotation)
        }
    }
    
    private func moveLocation() {
        let averageLocation = calculateAverageLocation()
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: averageLocation, span: span)
        mapView.setRegion(region, animated: true)
        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(locationData[0].latitude ?? "0") ?? 0.0, longitude: Double(locationData[0].longitude ?? "0") ?? 0.0), animated: true)
    }
    
    private func calculateAverageLocation() -> CLLocationCoordinate2D {
        guard !locationData.isEmpty
        else { return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) }
        let latitude = (locationData.map { Double($0.latitude ?? "0") ?? 0.0 }.reduce(0.0, +)) / Double(locationData.count)
        let longitude = (locationData.map { Double($0.longitude ?? "0") ?? 0.0 }.reduce(0.0, +)) / Double(locationData.count)
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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

// MARK: - MKMapViewDelegate
extension SearchMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MKUserLocation {
            return MKUserLocationView()
        }
        
        guard let marker = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationView.className) as? AnnotationView else {
            return AnnotationView()
        }
        
        return marker
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else { return }
        mapView.setCenter(coordinate, animated: true)
    }
}
