//
//  UIView+Preview.swift
//  Quiet
//
//  Created by Minkyeong Ko on 2022/08/25.
//

import SwiftUI

extension UIView {
    struct UIViewPreview<View: UIView>: UIViewRepresentable {
        let view: View
        init(_ builder: @autoclosure () -> View) {
            view = builder()
        }
            
        // MARK: - UIViewRepresentable
        func makeUIView(context: Context) -> UIView {
            return view
        }
        func updateUIView(_ view: UIView, context: Context) {
        }
    }

    func toPreview() -> some View {
        UIViewPreview(self)
    }
}
