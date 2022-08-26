//
//  ImageLiteral.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import UIKit

enum ImageLiteral {
    
    // MARK: - Button
    
    static var btnBack: UIImage { .load(systemName: "chevron.backward") }
    static var btnXmark: UIImage { .load(systemName: "xmark") }
    static var btnPlay: UIImage { .load(systemName: "play.fill") }
    static var btnPause: UIImage { .load(systemName: "pause.fill") }

    
    // MARK: - Image
    
    static var imgRightChevron: UIImage { .load(systemName: "chevron.right") }

    // MARK: - Icon

    static var icMagnifyingglass: UIImage { .load(systemName: "magnifyingglass") }
    static var icLocation: UIImage { .load(systemName: "location") }
    static var icLocationFill: UIImage { .load(systemName: "location.fill") }
    static var icMeasurement: UIImage { .load(systemName: "lines.measurement.horizontal")}

}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
