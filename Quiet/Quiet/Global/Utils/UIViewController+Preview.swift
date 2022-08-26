//
//  UIViewController+Preview.swift
//  Quiet
//
//  Created by Minkyeong Ko on 2022/08/25.
//

import UIKit
import SwiftUI

extension UIViewController {
    struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
        let viewController: ViewController

        init(_ builder: @autoclosure () -> ViewController) {
            viewController = builder()
        }

        // MARK: - UIViewControllerRepresentable
        func makeUIViewController(context: Context) -> ViewController {
            viewController
        }

        func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {

        }
    }

    func toPreview() -> some View {
        UIViewControllerPreview(self)
    }
}
