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
        static let donglocationBottomConstant: CGFloat = 165
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
            let image = locationBtnCliked ?
            ImageLiteral.icLocationFill
                .resize(to: CGSize(width: 25, height: 25)) :
                 
            ImageLiteral.icLocation
                .resize(to: CGSize(width: 25, height: 25))
            locationButton.setImage(image, for: .normal)
        }
    }
    private var circle: MKOverlay?
    private var noiseLevel: NoiseLevel = .level_1
    private var locationType: LocationType
    private var locationData: [InstallInfo]
    private var currentCoordinator: CLLocationCoordinate2D
    
    // MARK: - Init
    
    init(locationType: LocationType, locationData: [InstallInfo], currentCoordinator: CLLocationCoordinate2D) {
        self.locationType = locationType
        self.locationData = locationData
        self.currentCoordinator = currentCoordinator
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
        guard !locationData.isEmpty else {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: currentCoordinator, span: span)
            mapView.setRegion(region, animated: true)
            return
        }
        
        let averageLocation = calculateAverageLocation()
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: averageLocation, span: span)
        mapView.setRegion(region, animated: true)
        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(locationData[0].latitude ?? "0") ?? 0.0, longitude: Double(locationData[0].longitude ?? "0") ?? 0.0), animated: true)
    }
    
    private func calculateAverageLocation() -> CLLocationCoordinate2D {
        guard !locationData.isEmpty
        else { return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) }
        let averageLatitude = (locationData.map { Double($0.latitude ?? "0") ?? 0.0 }.reduce(0.0, +)) / Double(locationData.count)
        let averageLongitude = (locationData.map { Double($0.longitude ?? "0") ?? 0.0 }.reduce(0.0, +)) / Double(locationData.count)
        
        return CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
    }
    
    private func setupAnnoationCircle(with center: CLLocationCoordinate2D) {
        removeCircle()
        
        let distance = CLLocationDistance(300)
        circle = MKCircle(center: center, radius: distance)
        
        mapView.addOverlay(circle!)
    }
    
    private func removeCircle() {
        if let circle = self.circle {
            self.mapView.removeOverlay(circle)
            self.circle = nil
        }
    }
    
    // MARK: - Selector
    
    @objc
    private func manualButtonTapped() {
        let vc = ManualViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func locationButtonTapped() {
        mapView.showsUserLocation.toggle()
        locationBtnCliked.toggle()
        if mapView.showsUserLocation {
            mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            mapView.setUserTrackingMode(.none, animated: true)
        }
    }
    
    // MARK: - Network
    
    private func fetchSpecificLocationData(modelSerial: String, address: String, coordinate2D: CLLocationCoordinate2D) {
        IoTAPI().fetchInquiry(datasetNo: GeneralAPI.noiseDatasetNo, modelSerial: modelSerial, inqDt: Date.getCurrentDate(with: "20220801"), currPageNo: 1) { data in
            DispatchQueue.main.async {
                guard let currentNoise = data.last?.column14 else { return }
                let noiseLevel = getNoiseLevel(dbValue: Double(currentNoise) ?? 0.0)
                let noiseText = "\(noiseLevel.sheetComment)\n\(noiseLevel.level)"
                NotificationCenter.default.post(name: .noiseDetail, object: noiseText)
                NotificationCenter.default.post(name: .address, object: address)
                NotificationCenter.default.post(name: .deviceModel, object: modelSerial)
                NotificationCenter.default.post(name: .noiseLevel, object: noiseLevel)
                
                self.noiseLevel = noiseLevel
                self.setupAnnoationCircle(with: coordinate2D)
                NotificationCenter.default.post(name: .stopLottie, object: nil)
            }
        }
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
        NotificationCenter.default.post(name: .playLottie, object: nil)
        
        var modelSerial = ""
        var addressText = ""
        
        locationData.forEach {
            let isSameLongitude = Double($0.longitude ?? "0") == view.annotation?.coordinate.longitude
            let isSameLatitude = Double($0.latitude ?? "0") == view.annotation?.coordinate.latitude
            
            if isSameLatitude && isSameLongitude {
                guard let modlSerial = $0.modlSerial,
                      let address = $0.address
                else { return }
                modelSerial = modlSerial
                addressText = address
                
                return
            }
        }
        
        fetchSpecificLocationData(modelSerial: modelSerial, address: addressText, coordinate2D: coordinate)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = noiseLevel.color.withAlphaComponent(0.3)
        return circleRenderer
    }
}
