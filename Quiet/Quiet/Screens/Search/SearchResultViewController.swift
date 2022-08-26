//
//  SearchResultViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/25.
//

import UIKit

final class SearchResultViewController: SheetViewController<SearchMapViewController, SheetContainerViewController> {
    
    // MARK: - Properties

    private let searchLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    var locationText: String = "" {
        willSet {
            searchLocationLabel.text = newValue
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupNavigationPopGesture()
        setupNotificationCenter()
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

    // MARK: - Func
    
    private func setupNavigationPopGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(playLottie), name: .playLottie, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLottie), name: .stopLottie, object: nil)
    }
    
    // MARK: - Selector
    
    @objc
    private func playLottie() {
        setupLottieView()
    }
    
    @objc
    private func stopLottie() {
        stopLottieAnimation()
    }
}
