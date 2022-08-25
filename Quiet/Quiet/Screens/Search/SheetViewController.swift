//
//  SheetViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/25.
//

import UIKit

class SheetViewController<Content: UIViewController, BottomSheet: UIViewController>: BaseViewController, UIGestureRecognizerDelegate {
    
    struct BottomSheetConfiguration {
        let height: CGFloat
        let initialOffset: CGFloat
    }

    enum BottomSheetState {
        case initial, full
    }
    
    // MARK: - Properties
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.delegate = self
        pan.addTarget(self, action: #selector(handlePan))
        return pan
    }()
    
    private var topConstraint = NSLayoutConstraint()
    var state: BottomSheetState = .initial
    
    private let configuration: BottomSheetConfiguration
    let contentViewController: Content
    let bottomSheetViewController: BottomSheet
    
    // MARK: - Init
    
    init(contentViewController: Content,
         bottomSheetViewController: BottomSheet,
         bottomSheetConfiguration: BottomSheetConfiguration) {
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        self.configuration = bottomSheetConfiguration
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func setupLayout() {
        self.addChild(contentViewController)
        self.view.addSubview(contentViewController.view)
        
        contentViewController.view.constraint(to: view)
        contentViewController.didMove(toParent: self)
        
        self.addChild(bottomSheetViewController)
        self.view.addSubview(bottomSheetViewController.view)

        bottomSheetViewController.view.constraint(bottomSheetViewController.view.heightAnchor, constant: configuration.height)
        let sheetConstraints = bottomSheetViewController.view.constraint(top: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: -configuration.initialOffset, left: 0, bottom: 0, right: 0))
        topConstraint = sheetConstraints[.top] ?? NSLayoutConstraint()
        bottomSheetViewController.didMove(toParent: self)
    }
    
    override func configureUI() {
        bottomSheetViewController.view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Func
    
    private func showBottomSheet(animated: Bool = true) {
        self.topConstraint.constant = -configuration.height
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.state = .full
            })
        } else {
            self.view.layoutIfNeeded()
            self.state = .full
        }
    }
    
    private func hideBottomSheet(animated: Bool = true) {
        self.topConstraint.constant = -configuration.initialOffset
        
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseOut],
                           animations: {
                            self.view.layoutIfNeeded()
            }, completion: { _ in
                self.state = .initial
            })
        } else {
            self.view.layoutIfNeeded()
            self.state = .initial
        }
    }
    
    private func changeTopConstraint(to constant: CGFloat) {
        topConstraint.constant = constant
        self.view.layoutIfNeeded()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Selector
    
    @objc
    private func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: bottomSheetViewController.view)
        let velocity = sender.velocity(in: bottomSheetViewController.view)
        let yTranslationMagnitude = translation.y.magnitude
        
        switch ([sender.state], self.state) {
        case ([.began, .changed], .full):
            guard translation.y > 0 else { return }
            let topConstraint = -(configuration.height - yTranslationMagnitude)
            changeTopConstraint(to: topConstraint)
            
        case ([.began, .changed], .initial):
            let newConstant = -(configuration.initialOffset + yTranslationMagnitude)
            guard translation.y < 0 else { return }
            guard newConstant.magnitude < configuration.height else {
                self.showBottomSheet()
                return
            }
            changeTopConstraint(to: newConstant)
            
        case ([.ended], .full):
            let shouldHideSheet = yTranslationMagnitude >= configuration.height / 2 || velocity.y > 1000
            shouldHideSheet ? hideBottomSheet() : showBottomSheet()
            
        case ([.ended], .initial):
            let shouldShowSheet = yTranslationMagnitude >= configuration.height / 2 || velocity.y < -1000
            shouldShowSheet ? showBottomSheet() : hideBottomSheet()
            
        case ([.failed], .full):
            showBottomSheet()
            
        case ([.failed], .initial):
            hideBottomSheet()
            
        default:
            break
        }
    }
}
