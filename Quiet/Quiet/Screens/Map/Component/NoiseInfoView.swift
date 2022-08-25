//
//  NoiseInfoView.swift
//  Quiet
//
//  Created by DaeSeong on 2022/08/25.
//

import UIKit

class NoiseInfoView: UIStackView {
    // MARK: - Properties
    
    
    private let id: Int
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    private let markColorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    private let exampleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    private let listeningLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemCyan
        label.text = "▶︎ 들어보기"
        return label
    }()
    
    private let firstStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillEqually
        return view
    }()
    private let secondStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillEqually
        view.spacing = 5
        return view
    }()
    
    
    // MARK: - Init

    
    init(id: Int, noise: Noise){
        self.id = id
        title.text = "\(id).\"\(noise.description)"
        levelLabel.text = "✔️ 소음크기:\(noise.levelRange)"
        markColorLabel.text = "✔️ 표기색깔:\(noise.markColor)"
        exampleLabel.text = "✔️ 소음예시:\(noise.examples)"
        super.init(frame: .zero)
        setupLayout()
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Func
    
    
    func setupLayout() {
        self.addArrangedSubview(firstStackView)
        firstStackView.addArrangedSubview(title)
    
        self.addArrangedSubview(secondStackView)
        secondStackView.addArrangedSubview(levelLabel)
        secondStackView.addArrangedSubview(markColorLabel)
        secondStackView.addArrangedSubview(exampleLabel)
        secondStackView.addArrangedSubview(listeningLabel)
    }
    
    func configureUI() {
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .fillProportionally
        self.spacing = 16
    }
}
