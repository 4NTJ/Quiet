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
    
    private let searchLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    private let mapView = MKMapView()
        
    // MARK: - Init
    
    init(locationText: String) {
        searchLocationLabel.text = locationText
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
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
        
        let dismissAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        setupBackAction(dismissAction)
    }
    
    override func setupNavigationBar() {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: leftOffsetBackButton)
        let searchLocationLabel = makeBarButtonItem(with: searchLocationLabel)
        
        navigationItem.leftBarButtonItems = [backButton, searchLocationLabel]
    }
}
