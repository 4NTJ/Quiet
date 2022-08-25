//
//  BaseViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var backButton = BackButton()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
    }
    
    // MARK: - Func
    
    func setupLayout() {
        // Layout
    }
    
    func configureUI() {
        // UI configuration
        view.backgroundColor = .white
    }
    
    func setupBackAction(_ action: UIAction) {
        backButton.addAction(action, for: .touchUpInside)
    }
    
    func setupNavigationBar() {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: leftOffsetBackButton)
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    func makeBarButtonItem<T: UIView>(with view: T) -> UIBarButtonItem {
        return UIBarButtonItem(customView: view)
    }
    
    func removeBarButtonItemOffset(with button: UIButton, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(button)
        return offsetView
    }
}
