//
//  BackButton.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import UIKit

final class BackButton: UIButton {

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 44, height: 44)))
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func configUI() {
        self.setImage(ImageLiteral.btnBack, for: .normal)
        self.tintColor = .black
        self.contentMode = .scaleToFill
    }
}
