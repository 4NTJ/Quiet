//
//  LocationDetailTableViewCell.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/26.
//

import UIKit

final class LocationDetailTableViewCell: UITableViewCell {
    
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
        addSubview(addressLabel)
        addressLabel.constraint(top: locationLabel.bottomAnchor,
                                leading: leadingAnchor,
                                trailing: trailingAnchor,
                                padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 20))
        
        addSubview(soundLabel)
        soundLabel.constraint(top: addressLabel.bottomAnchor,
                              leading: leadingAnchor,
                              bottom: bottomAnchor,
                              padding: UIEdgeInsets(top: 12, left: 20, bottom: 20, right: 0))
    }
    
    private func configureUI() {
        selectionStyle = .none
    }
    
    func setLocationData(title: String, content: String?, address: String?) {
        locationLabel.text = title
        
        if let content = content {
            soundLabel.text = content
            soundLabel.setLineSpacing(lineSpacing: 6.0, lineHeightMultiple: 0.0)
            soundLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1.0)
        } else {
            soundLabel.text = "?????? ???????????? ???????????? ?????? ???????????????."
            soundLabel.textColor = .systemGray
        }
        
        if let address = address {
            addressLabel.text = address
        } else {
            addressLabel.text = "?????? ?????? ??????"
        }
    }
}
