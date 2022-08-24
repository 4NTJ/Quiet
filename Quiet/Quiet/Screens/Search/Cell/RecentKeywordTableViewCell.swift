//
//  RecentKeywordTableViewCell.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import UIKit

final class RecentKeywordTableViewCell: UITableViewCell {
    
    // MARK: - properties
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.text = "강남구"
        return label
    }()
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.btnXmark, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        addSubview(keywordLabel)
        keywordLabel.constraint(leading: safeAreaLayoutGuide.leadingAnchor,
                                centerY: safeAreaLayoutGuide.centerYAnchor,
                                padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        
        addSubview(removeButton)
        removeButton.constraint(trailing: safeAreaLayoutGuide.trailingAnchor,
                                centerY: safeAreaLayoutGuide.centerYAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18))
    }
}
