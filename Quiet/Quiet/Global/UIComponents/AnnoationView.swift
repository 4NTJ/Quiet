//
//  AnnoationView.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import MapKit

final class AnnotationView: MKMarkerAnnotationView {
    
    override func draw(_ rect: CGRect) {
        glyphImage = ImageLiteral.icMeasurement
        glyphTintColor = .white
        markerTintColor = .systemCyan
        
        super.draw(rect)
    }
}
