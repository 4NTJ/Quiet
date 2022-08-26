//
//  DetailViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import UIKit

func getNoiseLevel(dbValue: Double) -> NoiseLevel {
    switch dbValue {
    case 20...40:
        return NoiseLevel.level_1
    case 41...60:
        return NoiseLevel.level_2
    case 61...70:
        return NoiseLevel.level_3
    case 71...90:
        return NoiseLevel.level_4
    case 91...120:
        return NoiseLevel.level_5
    default:
        return NoiseLevel.level_1 // ?
    }
}

enum NoiseLevel {
    case level_1
    case level_2
    case level_3
    case level_4
    case level_5
    
    var comment: String {
        get {
            switch self {
            case .level_1:
                return "“😌 수면에 영향이 없는 조용한 지역이에요”"
            case .level_2:
                return "“🥱 조용한 도서관 정도의 소음이 있어요”"
            case .level_3:
                return "“🙄 시끄러운 사무실 정도의 소음이 있어요”"
            case .level_4:
                return "“😨 공사장만큼 시끄러울 가능성이 있어요”"
            case .level_5:
                return "“😱 소음이 인체에 영향을 주는 위험 지역이에요”"
            }
        }
    }
    
    var level: String {
        get {
            switch self {
            case .level_1:
                return "⚪️ 소음레벨 20~40dB"
            case .level_2:
                return "🔵 소음레벨 40~60dB"
            case .level_3:
                return "🟢 소음레벨 60~70dB"
            case .level_4:
                return "🟡 소음레벨 70~90dB"
            case .level_5:
                return "🔴 소음레벨 90dB~"
            }
        }
    }
    
    var sheetComment: String {
        switch self {
        case .level_1:
            return "😌 “수면에 영향이 없는 조용한 지역이에요”"
        case .level_2:
            return "🥱 “조용한 도서관 정도의 소음이 있어요”"
        case .level_3:
            return "🙄 “시끄러운 사무실 정도의 소음이 있어요”"
        case .level_4:
            return "😨 “공사장만큼 시끄러울 가능성이 있어요”"
        case .level_5:
            return "😱 “소음이 인체에 영향을 주는 위험 지역이에요”"
        }
    }
    
    var color: UIColor {
        switch self {
        case .level_1:
            return .systemGray
        case .level_2:
            return .systemBlue
        case .level_3:
            return .systemGreen
        case .level_4:
            return .systemYellow
        case .level_5:
            return .systemRed
        }
    }
}

class DetailViewController: BaseViewController {

    // MARK: - Properties
    
    var averageNoiseDb: Double = 30.0
    
    let hours: [String] = (0...24).map{ num in
        String(num)
    }
    var dbValues: [Double] = [68, 54, 56, 70, 80, 46, 55, 60, 64, 50, 55, 56, 68, 54, 56, 70, 80, 46, 55, 60, 64, 50, 55, 56, 68, 45]
    
    let weekLabels = ["주말", "평일"]
    var barDbValues: [Double] = [68, 54]
    
    var lineChartView = NoiseLineChartView()
    var barChartView = NoiseBarChartView()
    
    private lazy var infoBoxView: UIStackView = {
        let noiseInfo = UILabel()
        noiseInfo.text = noiseLevel.comment
        noiseInfo.font = .systemFont(ofSize: 16)
        noiseInfo.numberOfLines = 0
        noiseInfo.lineBreakMode = .byCharWrapping
        
        let noiseLabel = UILabel()
        noiseLabel.text = noiseLevel.level
        noiseLabel.font = .systemFont(ofSize: 16)
        
        let infoBox = UIStackView(arrangedSubviews: [noiseInfo, noiseLabel])
        infoBox.axis = .vertical
        infoBox.spacing = 10
        infoBox.widthAnchor.constraint(equalToConstant: screenWidth - 40).isActive = true
        infoBox.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 15)
        infoBox.isLayoutMarginsRelativeArrangement = true
        infoBox.backgroundColor = UIColor.white
        infoBox.layer.shadowColor = UIColor.gray.cgColor
        infoBox.layer.shadowOpacity = 0.25
        infoBox.layer.shadowRadius = 10
        infoBox.layer.shadowPath = nil
        
        return infoBox
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    private let dayChartLabel: UILabel = {
        let chartTitle = UILabel()
        chartTitle.text = "시간별 소음 변화"
        chartTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        return chartTitle
    }()
    private let dayChartDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "최근 일주일 평균(22.08.15~22.08.22)"
        descriptionLabel.font = .systemFont(ofSize: 10)
        return descriptionLabel
    }()
    private let weeklyChartLabel: UILabel = {
        let chartTitle = UILabel()
        chartTitle.text = "평일/주말 소음 비교"
        chartTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        return chartTitle
    }()
    private let weeklyChartDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "최근 한 달 평균(22.07)"
        descriptionLabel.font = .systemFont(ofSize: 10)
        return descriptionLabel
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let scrollContentView = UIView()
    
    var navigationTitle: String
    var noiseLevel: NoiseLevel
    
    // MARK: - Init
    
    init(title: String, noiseLevel: NoiseLevel, deviceModel: String) {
        self.navigationTitle = title
        self.noiseLevel = noiseLevel
        super.init()
        self.fetchData(deviceModel: deviceModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
        setupNavigationBar()
        let action = UIAction { _ in
            self.navigationController?.popViewController(animated: true)
        }
        setupBackAction(action)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+5.0, execute: {
            self.setupLineChartView()
            self.setupBarChartView()
            self.stopLottieAnimation()
        })
    }
    
    private func fetchData(deviceModel: String) {
        let startingDateInt = 20220701
        var times: [Int] = Array(repeating: 0, count: 25)
        var days: [Int] = Array(repeating: 0, count: 7)

        setupLottieView()
        
        for i in 0...7 {
            IoTAPI().fetchInquiry(datasetNo: 48, modelSerial: deviceModel, inqDt: String(startingDateInt+i), currPageNo: 1) { data in
                let newData = data.map { Int($0.column14 ?? "0") ?? 0 }
                times = zip(times, newData).map(+)
                days[((startingDateInt + i) % 100)%7] = times.reduce(0, +)/24
                self.dbValues = times.map{ hourVal in
                    return Double(hourVal/7)
                }
                self.barDbValues = [Double((days[5] + days[6])/2)/7, Double((days[0] + days[1] + days[2] + days[3] + days[4])/5)/7]
                print("barDbValues: \(self.barDbValues)")
            }
        }
    }
    
    
    // MARK: - Func
    
    override func setupLayout() {
        view.addSubview(scrollView)
        scrollView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.constraint(to: scrollView)
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollContentView.addSubview(infoBoxView)
        infoBoxView.constraint(top: scrollContentView.topAnchor,
                               centerX: scrollContentView.centerXAnchor,
                               padding: .init(top: 20.0, left: 0, bottom: 0, right: 0)
        )
        
        scrollContentView.addSubview(dayChartLabel)
        dayChartLabel.constraint(top: infoBoxView.bottomAnchor,
                                 leading: scrollContentView.leadingAnchor,
                                 padding: .init(top: 30.0, left: 20.0, bottom: 0, right: 0))
        
        scrollContentView.addSubview(dayChartDescriptionLabel)
        dayChartDescriptionLabel.constraint(top: dayChartLabel.bottomAnchor,
                                 leading: scrollContentView.leadingAnchor,
                                 padding: .init(top: 10.0, left: 20.0, bottom: 0, right: 0))
        
        scrollContentView.addSubview(lineChartView)
        lineChartView.constraint(top: dayChartDescriptionLabel.bottomAnchor,
                                 leading: dayChartDescriptionLabel.leadingAnchor,
                                 trailing: infoBoxView.trailingAnchor,
                                 padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        lineChartView.constraint(lineChartView.heightAnchor, constant: 200)
        
        scrollContentView.addSubview(separatorView)
        separatorView.constraint(separatorView.heightAnchor, constant: 5)
        separatorView.constraint(top: lineChartView.bottomAnchor,
                                 leading: scrollContentView.leadingAnchor,
                                 trailing: scrollContentView.trailingAnchor,
                                 padding: .init(top: 30.0, left: 0, bottom: 0, right: 0))
        
        scrollContentView.addSubview(weeklyChartLabel)
        weeklyChartLabel.constraint(top: separatorView.bottomAnchor,
                                    leading: scrollContentView.leadingAnchor,
                                    padding: .init(top: 30.0, left: 20.0, bottom: 0, right: 0))
        
        scrollContentView.addSubview(weeklyChartDescriptionLabel)
        weeklyChartDescriptionLabel.constraint(top: weeklyChartLabel.bottomAnchor,
                                 leading: scrollContentView.leadingAnchor,
                                 padding: .init(top: 10.0, left: 20.0, bottom: 0, right: 0))
        
        scrollContentView.addSubview(self.barChartView)
        barChartView.constraint(barChartView.heightAnchor, constant: 200)
        barChartView.constraint(
            top: weeklyChartDescriptionLabel.bottomAnchor,
            leading: infoBoxView.leadingAnchor,
            bottom: scrollContentView.bottomAnchor,
            trailing: infoBoxView.trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 20, right: 0)
        )

    }
    
    override func configureUI() {
        view.backgroundColor = .white
        
        title = navigationTitle
    }
    
    private func setupLineChartView() {
        self.lineChartView.setupLineChart(dataPoints: hours, values: dbValues)
        self.lineChartView.setupAverageLineChart(dataPoints: hours, values: dbValues)
    }
    
    private func setupBarChartView() {
        self.barChartView.setupBarChart(dataPoints: weekLabels, values: barDbValues)
    }
}
