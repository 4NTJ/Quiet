//
//  ManualViewController.swift
//  Quiet
//
//  Created by DaeSeong on 2022/08/25.
//

import SafariServices
import UIKit

class ManualViewController: UIViewController {
    // MARK: - Properties
    

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isDirectionalLockEnabled = true
        return view
    }()
    private let introductionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "콰이어트에서는 ‘국가소음정보시스템’의 \n소음 크기 분류를 기준으로 각 지역 색깔을 \n다르게 나타냈어요! \n아래 분류를 통해 서울시 지역별 소음 정도를 \n확인해보세요 👀"
        label.textColor = .systemGray
        label.setLineSpacing(lineHeightMultiple: 1.4)
        return label
    }()
    // FIXME: - 추후 forEach로 정리예정
    private let firstNoiseInfoView: NoiseInfoView = {
        let view = NoiseInfoView(id: 1,
                                 noise: Noise.sampleData[0])
        return view
    }()
    private let secondNoiseInfoView: NoiseInfoView = {
        let view = NoiseInfoView(id: 2,
                                 noise: Noise.sampleData[1])
        return view
    }()
    private let thirdNoiseInfoView: NoiseInfoView = {
        let view = NoiseInfoView(id: 3,
                                 noise: Noise.sampleData[2])
        return view
    }()
    private let fourthNoiseInfoView: NoiseInfoView = {
        let view = NoiseInfoView(id: 4,
                                 noise: Noise.sampleData[3])
        return view
    }()
    private let fifthNoiseInfoView: NoiseInfoView = {
        let view = NoiseInfoView(id: 5,
                                 noise: Noise.sampleData[4])
        return view
    }()
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillProportionally
        view.spacing = 30
        return view
    }()
    private let lastView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillProportionally
        view.spacing = 5
        return view
    }()
    private let secondLastLabel: UILabel = {
        let label = UILabel()
        label.text = "더 많은 정보를 알고 싶다면? 👇"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    private let linkButton: UIButton = {
        let button = UIButton()
        button.setTitle("소음 관련 정보 더 알아보기", for: .normal)
        button.setTitleColor(.systemCyan, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkButton.addTarget(self,
                             action: #selector(linkTapped),
                             for: .touchUpInside)
        setDelegation()
        setupLayout()
        configureUI()
        
    }
    
    
    // MARK: - Func
    
    private func setDelegation() {
        firstNoiseInfoView.delegate = self
        secondNoiseInfoView.delegate = self
        thirdNoiseInfoView.delegate = self
        fourthNoiseInfoView.delegate = self
        fifthNoiseInfoView.delegate = self

    }
    
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.constraint(to: view)
        
        scrollView.addSubview(introductionLabel)
        introductionLabel.constraint(top: scrollView.topAnchor,
                                     leading: view.leadingAnchor,
                                     trailing: view.trailingAnchor,
                                     padding: UIEdgeInsets(top: 0,
                                                           left: 20,
                                                           bottom: 0,
                                                           right: 20))
        
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(firstNoiseInfoView)
        stackView.addArrangedSubview(secondNoiseInfoView)
        stackView.addArrangedSubview(thirdNoiseInfoView)
        stackView.addArrangedSubview(fourthNoiseInfoView)
        stackView.addArrangedSubview(fifthNoiseInfoView)
        stackView.addArrangedSubview(secondLastLabel)
        stackView.addArrangedSubview(linkButton)
        stackView.addArrangedSubview(lastView)
        
        lastView.addArrangedSubview(secondLastLabel)
        lastView.addArrangedSubview(linkButton)
        
        secondLastLabel.constraint(leading: lastView.leadingAnchor,
                                   trailing: lastView.trailingAnchor)
        
        linkButton.constraint(leading: lastView.leadingAnchor,
                              trailing: lastView.trailingAnchor)
        
        stackView.constraint(
            top: introductionLabel.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: view.trailingAnchor
            ,padding: UIEdgeInsets(top: 30,
                                   left: 20,
                                   bottom: 0,
                                   right: 20))
        
        
        
    }
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        title = "소음 분류"
    }
    
    @objc func linkTapped() {
        let linkUrl = NSURL(string: "https://www.noiseinfo.or.kr/inform/noise.do")
        let safariView = SFSafariViewController(url: linkUrl! as URL)
        self.present(safariView, animated: true, completion: nil)
    }
}

// MARK: -

extension ManualViewController: ListeningDelegate {
    func pausePreviusSound(id: Int) {
        switch id {
        case 1:
            firstNoiseInfoView.isSoundClicked = false
        case 2:
            secondNoiseInfoView.isSoundClicked = false
        case 3:
            thirdNoiseInfoView.isSoundClicked = false
        case 4:
            fourthNoiseInfoView.isSoundClicked = false
        case 5:
            fifthNoiseInfoView.isSoundClicked = false
        default:
            break
        }
        
    }
}
