//
//  SelectedInfoView.swift
//  Quiet
//
//  Created by DaeSeong on 2022/08/27.
//

import UIKit

class SelectedInfoView: UIView {
    // MARK: - Properties
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let nextIconImageView: UIImageView = {
        let imageView = UIImageView(image: ImageLiteral.imgRightChevron)
        imageView.tintColor = .systemCyan
        return imageView
    }()
    private let soundLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Init

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Func
    
    
    private func setupLayout() {
        addSubview(locationLabel)
        locationLabel.constraint(top: topAnchor,
                                 leading: leadingAnchor,
                                 padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        addSubview(nextIconImageView)
        nextIconImageView.constraint(leading: locationLabel.trailingAnchor,
                                     centerY: locationLabel.centerYAnchor,
                                     padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        
        addSubview(soundLabel)
        soundLabel.constraint(top: locationLabel.bottomAnchor,
                              leading: leadingAnchor,
                              bottom: bottomAnchor,
                              padding: UIEdgeInsets(top: 12, left: 20, bottom: 20, right: 0))
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        self.isHidden = true
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor(red: 0,
                                         green: 0,
                                         blue: 0,
                                         alpha: 0.1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
    }
    
    func setLocationData(title: String, content: String?) {
        locationLabel.text = title
        if let content = content {
            soundLabel.text = content
        }
}
}
