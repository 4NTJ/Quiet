//
//  ImageLiteral.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import UIKit

enum ImageLiteral {
    
    // MARK: - icon
    
    static var exampleIcon: UIImage { .load(name: "btnList") }
    static var icMagnifyingglass: UIImage { .load(systemName: "magnifyingglass") }
    static var icLocation: UIImage { .load(systemName: "location") }
    static var icLocationFill: UIImage { .load(systemName: "location.fill") }

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
