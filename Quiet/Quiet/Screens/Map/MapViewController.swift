//
//  MapViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import MapKit
import UIKit

class MapViewController: BaseViewController {
    
    private enum Size {
        static let infoViewWidth: CGFloat = UIScreen.main.bounds.size.width - 64
        static let infoViewHeight: CGFloat = 150
        static let infoViewBottomOffset: CGFloat = 20

    }
    
    
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
    var locationText: String = ""
    var modelSerial = ""
    var addressText = ""
    private var circle: MKOverlay?

    private var noiseLevel: NoiseLevel = .level_1

    private var locationData: [InstallInfo] = []

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
    
    private let selectedInfoView = SelectedInfoView()
    
    
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationUsagePermission()
        setDelegation()
        setupLayout()
        btnAddTargets()
        setAnnotation()
        setMapRegion()
        setupNavigationPopGesture()
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
        mapView.delegate = self
        searchBarView.delegate = self
    }
    
     override func setupLayout() {
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
        
        mapView.addSubview(selectedInfoView)
        selectedInfoView.constraint(selectedInfoView.heightAnchor,
                                    constant: CGFloat(Size.infoViewHeight))
        selectedInfoView.constraint(leading: mapView.leadingAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            trailing: mapView.trailingAnchor,
                            padding: UIEdgeInsets(top: 0,
                                                  left: 20,
                                                  bottom: CGFloat(Size.infoViewBottomOffset) + view.safeAreaInsets.bottom,
                                                  right: 20))
    }
    
    private func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupNavigationPopGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func btnAddTargets() {
        manualButton.addTarget(self, action: #selector(manualButtonTapped), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        selectedInfoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedInfoViewTapped)))
    }
    
    private func setAnnotation() {
        fetchLocationNoiseData { data in
            data.forEach { [weak self] in
                let annotation = MKPointAnnotation()
                guard let latitude = Double($0.latitude ?? "0"),
                      let longitude = Double($0.longitude ?? "0") else { return }
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                self?.mapView.addAnnotation(annotation)
            }
        }
    }
    
    private func setMapRegion() {
        guard let locationCoorinate = locationManager.location?.coordinate else {return}
            let region = MKCoordinateRegion(center: locationCoorinate, span: MKCoordinateSpan(latitudeDelta: 0.016, longitudeDelta: 0.016) )
        mapView.setRegion(region, animated: true)
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
    
    
    // MARK: - Network

    
    private func fetchLocationNoiseData(completion: @escaping (([InstallInfo]) -> ())) {
        IoTAPI().fetchInstlInfo(datasetNo: GeneralAPI.noiseDatasetNo) { [weak self] data in
            self?.locationData = data
            completion(data)
        }
    }
    
    private func fetchSpecificLocationData(modelSerial: String, address: String, coordinate2D: CLLocationCoordinate2D) {
        IoTAPI().fetchInquiry(datasetNo: GeneralAPI.noiseDatasetNo, modelSerial: modelSerial, inqDt: Date.getCurrentDate(with: "20220801"), currPageNo: 1) { data in
            DispatchQueue.main.async {
                guard let currentNoise = data.last?.column14 else { return }
                let noiseLevel = getNoiseLevel(dbValue: Double(currentNoise) ?? 0.0)
                let noiseText = "\(noiseLevel.sheetComment)\n\(noiseLevel.level)"

                self.noiseLevel = noiseLevel
                self.selectedInfoView.setLocationData(content: noiseText,
                                                       address: address)
                self.setupAnnoationCircle(with: coordinate2D)
                self.stopLottieAnimation()
            }
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
    
    @objc
    private func selectedInfoViewTapped() {
        guard !locationData.isEmpty else { return }
        let viewController = DetailViewController(title: locationText, noiseLevel: noiseLevel, deviceModel: modelSerial)
        navigationController?.pushViewController(viewController, animated: true)
    }
  
}

// MARK: - CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(.follow, animated: true)
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


// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
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
        setupLottieView()
        guard let coordinate = view.annotation?.coordinate else { return }
        mapView.setCenter(coordinate, animated: true)
        selectedInfoView.isHidden = false
        selectedInfoView.setLocationTitle(title: "")
        selectedInfoView.setLocationData(content: "", address: "")

        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.locationButton.transform = .init(translationX: 0, y: -(Size.infoViewHeight + Size.infoViewBottomOffset + view.safeAreaInsets.bottom ))
            self?.manualButton.transform = .init(translationX: 0, y:-(Size.infoViewHeight + Size.infoViewBottomOffset + view.safeAreaInsets.bottom))
        }, completion: nil)
        

        
        locationData.forEach {

            let isSameLongitude = Double($0.longitude ?? "0") == view.annotation?.coordinate.longitude
            let isSameLatitude = Double($0.latitude ?? "0") == view.annotation?.coordinate.latitude

            if isSameLatitude && isSameLongitude {
                guard let modlSerial = $0.modlSerial,
                      let address = $0.address
                else { return }
                modelSerial = modlSerial
                addressText = address
                let splitAddress = address.split(separator: " ").map { String($0) }
                locationText = splitAddress[2]
                return
            }
        }
        selectedInfoView.setLocationTitle(title: locationText)
        fetchSpecificLocationData(modelSerial: modelSerial, address: addressText, coordinate2D: coordinate)

    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedInfoView.isHidden = true
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.locationButton.transform = .identity
            self?.manualButton.transform = .identity
        }, completion: nil)
        
        selectedInfoView.setLocationTitle(title: "")
        selectedInfoView.setLocationData(content: "", address: "")
        removeCircle()

    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = noiseLevel.color.withAlphaComponent(0.3)
        return circleRenderer
    }
    
}
