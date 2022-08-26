//
//  SearchTableViewCell.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/25.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {

    // MARK: - properties
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
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
        contentView.addSubview(keywordLabel)
        keywordLabel.constraint(leading: safeAreaLayoutGuide.leadingAnchor,
                                centerY: safeAreaLayoutGuide.centerYAnchor,
                                padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }
    
    private func makeAddressWithoutCountry(with splitedKeyword: [String.SubSequence]) -> String {
        var address: String = ""
        
        for index in 1..<splitedKeyword.count {
            address += splitedKeyword[index] + " "
        }
        
        return address
    }
    
    func setKeyword(to keyword: String) {
        let splitKeyword = keyword.split(separator: " ")
        let isCountryWritten = splitKeyword[0] == "대한민국"
        keywordLabel.text = isCountryWritten ? makeAddressWithoutCountry(with: Array(splitKeyword)) : keyword
    }
}
