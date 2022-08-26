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
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
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
                                 padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0))
        
        addSubview(nextIconImageView)
        nextIconImageView.constraint(leading: locationLabel.trailingAnchor,
                                     centerY: locationLabel.centerYAnchor,
                                     padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        
        addSubview(addressLabel)
        addressLabel.constraint(top: locationLabel.bottomAnchor,
                                leading: leadingAnchor,
                                trailing: trailingAnchor,
                                padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 20))
        
        addSubview(soundLabel)
        soundLabel.constraint(top: addressLabel.bottomAnchor,
                              leading: leadingAnchor,
                              padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 0))
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
        self.isUserInteractionEnabled = true

    }
    
    func setLocationTitle(title: String) {
        locationLabel.text = title
    }
    func setLocationData(content: String, address: String) {
        soundLabel.text = content
        soundLabel.setLineSpacing(lineSpacing: 6.0, lineHeightMultiple: 0.0)
        soundLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        addressLabel.text = address
        
    }
}

