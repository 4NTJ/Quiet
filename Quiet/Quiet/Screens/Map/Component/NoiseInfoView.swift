//
//  NoiseInfoView.swift
//  Quiet
//
//  Created by DaeSeong on 2022/08/25.
//
import AVFoundation
import UIKit


protocol ListeningDelegate: AnyObject {
    func pausePreviusSound(id: Int)
}

class NoiseInfoView: UIStackView {
    // MARK: - Properties
    
    
    private let id: Int
    var audioPlayer: AVPlayer?
    weak var delegate: ListeningDelegate?
    var isSoundClicked = false {
        didSet{
            if isSoundClicked {
                listeningButton.setImage(ImageLiteral.btnPause, for: .normal)
                guard let playingId = UserData<Int>.getValue(forKey: DataKeys.playing) else { audioPlayer?.play() ; return }
                
                delegate?.pausePreviusSound(id: playingId)
                UserData<Int>.setValue(id, forKey: DataKeys.playing)
                audioPlayer?.play()
            } else {
                listeningButton.setImage(ImageLiteral.btnPlay, for: .normal)
                UserData<Int>.setValue(-1, forKey: DataKeys.playing)

                audioPlayer?.pause()

            }
        }
    }
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    private let markColorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    private let exampleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    private lazy var listeningButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.systemCyan, for: .normal)
        button.tintColor = .systemCyan
        button.setTitle(" 들어보기", for: .normal)
        button.setImage(ImageLiteral.btnPlay, for: .normal)
        button.addTarget(self, action: #selector(soundTapped), for: .touchUpInside)
        return button
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
    
    
    private func setupLayout() {
        self.addArrangedSubview(firstStackView)
        firstStackView.addArrangedSubview(title)
    
        self.addArrangedSubview(secondStackView)
        secondStackView.addArrangedSubview(levelLabel)
        secondStackView.addArrangedSubview(markColorLabel)
        secondStackView.addArrangedSubview(exampleLabel)
        secondStackView.addArrangedSubview(listeningButton)
    }
    
    private func configureUI() {
        self.axis = .vertical
        self.alignment = .leading
        self.distribution = .fillProportionally
        self.spacing = 16
    }
    
    @objc private func soundTapped() {
        guard let url = Bundle.main.url(forResource: Noise.sampleData[id-1].soundName, withExtension: "mp3") else {return}
        do {
            audioPlayer = try AVPlayer(url: url)
        } catch {
            print("audio file error")
        }
        isSoundClicked.toggle()

    }
}
