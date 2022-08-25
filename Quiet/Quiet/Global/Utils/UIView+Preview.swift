//
//  UIView+Preview.swift
//  Quiet
//
//  Created by Minkyeong Ko on 2022/08/25.
//

import SwiftUI

extension UIView {
    internal struct UIViewPreview<View: UIView>: UIViewRepresentable {
        public let view: View
        public init(_ builder: @autoclosure () -> View) {
            view = builder()
        }
            
        // MARK: - UIViewRepresentable
        public func makeUIView(context: Context) -> UIView {
            return view
        }
        public func updateUIView(_ view: UIView, context: Context) {
        }
    }

    func toPreview() -> some View {
        UIViewPreview(self)
    }
}
