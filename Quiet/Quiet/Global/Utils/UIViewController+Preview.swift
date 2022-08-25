//
//  UIViewController+Preview.swift
//  Quiet
//
//  Created by Minkyeong Ko on 2022/08/25.
//

import UIKit
import SwiftUI

extension UIViewController {
    internal struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
        public let viewController: ViewController

        public init(_ builder: @autoclosure () -> ViewController) {
            viewController = builder()
        }

        // MARK: - UIViewControllerRepresentable
        public func makeUIViewController(context: Context) -> ViewController {
            viewController
        }

        public func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {

        }
    }

    func toPreview() -> some View {
        UIViewControllerPreview(self)
    }
}
