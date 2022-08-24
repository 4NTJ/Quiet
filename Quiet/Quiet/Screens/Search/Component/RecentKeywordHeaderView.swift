//
//  RecentKeywordHeaderView.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import UIKit

final class RecentKeywordHeaderView: UIView {
    
    var didTappedClearAll: (() -> ())?
    
    // MARK: - properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색한 지역"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 지우기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .light)
        return button
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.constraint(leading: safeAreaLayoutGuide.leadingAnchor,
                              bottom: bottomAnchor,
                              padding: UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 0))
        
        addSubview(removeButton)
        removeButton.constraint(bottom: bottomAnchor,
                                trailing: safeAreaLayoutGuide.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 16))
        
        addSubview(separatorView)
        separatorView.constraint(separatorView.heightAnchor, constant: 1)
        separatorView.constraint(leading: leadingAnchor,
                                 bottom: bottomAnchor,
                                 trailing: trailingAnchor,
                                 padding: .zero)
    }
    
    private func configureUI() {
        backgroundColor = .white
    }
    
    private func setupButtonAction() {
        let removeAction = UIAction { [weak self] _ in
            self?.didTappedClearAll?()
        }
        removeButton.addAction(removeAction, for: .touchUpInside)
    }
}
