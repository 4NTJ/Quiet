//
//  MapViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

     // MARK: - Properties
    
    
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
    
    
   
    // MARK: - View Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        getLocationUsagePermission()
        locationManager.delegate = self
       
    }

    override func viewWillDisappear(_ animated: Bool) {
            locationManager.stopUpdatingLocation()
        }
    
    
    // MARK: - Func
    
    
    func setupLayout() {
        view.addSubview(mapView)
        mapView.constraint(to: view)
        
        
      
           }
    
    func getLocationUsagePermission() {
           locationManager.requestWhenInUseAuthorization()
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


