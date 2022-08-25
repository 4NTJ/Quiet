//
//  SearchBarView.swift
//  Quiet
//
//  Created by DaeSeong on 2022/08/25.
//

import UIKit

class SearchBarView: UIView {
    // MARK: - Properties
    
    
    private let searchImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.load(systemName: "magnifyingglass")
        view.tintColor = .black
        return view
    }()
    
    private let searchField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "지역구 혹은 동을 입력해주세요"
        textfield.font = .systemFont(ofSize: 18, weight: .medium)
        textfield.borderStyle = .none
        textfield.clearButtonMode = .whileEditing
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.returnKeyType = .search
        return textfield
    }()
    
    
    // MARK: - Init
    
    
    init(){
        super.init(frame: .zero)
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Func
    
    func setupLayout() {
        self.addSubview(searchImage)
        searchImage.constraint(searchImage.widthAnchor, constant: 20)
        searchImage.constraint(leading: self.leadingAnchor,
                               centerY: self.centerYAnchor,
                               padding: UIEdgeInsets(top: 0,
                                                     left: 16,
                                                     bottom: 0,
                                                     right: 0))
        self.addSubview(searchField)
        searchField.constraint(leading: searchImage.trailingAnchor,
                               trailing: self.trailingAnchor,
                               centerY: self.centerYAnchor,
                               padding: UIEdgeInsets(top: 0,
                                                     left: 16,
                                                     bottom: 0,
                                                     right: 20))
    }
    
    func configureUI() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor(red: 0,
                                         green: 0,
                                         blue: 0,
                                         alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
        
        self.backgroundColor = .white
    }
}
