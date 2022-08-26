//
//  RecentKeywordTableViewCell.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import UIKit

final class RecentKeywordTableViewCell: UITableViewCell {
    
    var didTappedRemove: ((String) -> ())?
    
    // MARK: - Properties
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.btnXmark, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Func
    
    private func setupLayout() {
        contentView.addSubview(keywordLabel)
        keywordLabel.constraint(leading: safeAreaLayoutGuide.leadingAnchor,
                                centerY: safeAreaLayoutGuide.centerYAnchor,
                                padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        
        contentView.addSubview(removeButton)
        removeButton.constraint(trailing: safeAreaLayoutGuide.trailingAnchor,
                                centerY: safeAreaLayoutGuide.centerYAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18))
    }
    
    private func setupButtonAction() {
        let removeAction = UIAction { [weak self] _ in
            guard let keyword = self?.keywordLabel.text else { return }
            self?.didTappedRemove?(keyword)
        }
        removeButton.addAction(removeAction, for: .touchUpInside)
    }
    
    func setKeyword(to keyword: String) {
        keywordLabel.text = keyword
    }
}
