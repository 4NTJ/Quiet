//
//  CircleButton.swift
//  Quiet
//
//  Created by DaeSeong on 2022/08/25.
//

import UIKit

class CircleButton: UIButton {
    
    // MARK: - Init

    init(buttonImage: String) {
        super.init(frame: .zero)
        
        self.setImage(UIImage.load(systemName: buttonImage), for: .normal)
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Func
    
    func setupLayout() {
        self.constraint(self.widthAnchor, constant: 50)
        self.constraint(self.heightAnchor, constant: 50)
        

    }
    func configureUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 25
        self.tintColor = .black

    }
}

