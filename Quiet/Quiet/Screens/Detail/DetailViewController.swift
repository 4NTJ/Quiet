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
                return "“🥱 시끄러운 사무실 정도의 소음이 있어요”"
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
}

class DetailViewController: UIViewController {

    // MARK: - Properties
    
    var locationName: String = "증산동"
    var averageNoiseDb: Double = 30.0
    
    let hours: [String] = (0...24).map{ num in
        String(num)
    }
    var dbValues: [Double] = [68, 54, 56, 70, 80, 46, 55, 60, 64, 50, 55, 56, 68, 54, 56, 70, 80, 46, 55, 60, 64, 50, 55, 56, 68]
    
    let weekLabels = ["주말", "평일"]
    let barDbValues: [Double] = [68, 54]
    
    var lineChartView = NoiseLineChartView()
    var barChartView = NoiseBarChartView()
    
    private lazy var backButton: UIButton = {
        let button = BackButton()
        let buttonAction = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    private lazy var infoBoxView: UIStackView = {
        let noiseInfo = UILabel()
        
        // 값이 범위 내에 없다면?
        let noiseLevelEnum = getNoiseLevel(dbValue: averageNoiseDb)
        noiseInfo.text = noiseLevelEnum.comment
        let noiseLevel = UILabel()
        noiseLevel.text = noiseLevelEnum.level
        
        let infoBox = UIStackView(arrangedSubviews: [noiseInfo, noiseLevel])
        infoBox.axis = .vertical
        infoBox.spacing = 10
        infoBox.widthAnchor.constraint(equalToConstant: screenWidth - 40).isActive = true
        infoBox.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: .zero)
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
    private let weeklyChartLabel: UILabel = {
        let chartTitle = UILabel()
        chartTitle.text = "평일/주말 소음 비교"
        chartTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        return chartTitle
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    private let scrollContentView = UIView()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
        setupNavigationBar()

        // Do any additional setup after loading the view.
        let startingDateInt = 20220601
        var times: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

        for i in 0...7 {
            IoTAPI().fetchInquiry(datasetNo: 48, modelSerial: "OC3CL200011", inqDt: String(startingDateInt+i), currPageNo: 1) { data in
                let newData = data.map { Int($0.column14 ?? "0") ?? 0 }
                times = zip(times, newData).map(+)
                print("startingDate : ", startingDateInt+i)
                print(times)
                self.dbValues = times.map{ hourVal in
                    Double(hourVal/7)
                }
                print("dbValues: \(self.dbValues)")
                
                DispatchQueue.main.async {
                    self.setupLineChartView()
                    self.setupBarChartView()
                }
            }
        }
    }
    
    // MARK: - Func
    
    private func setupLayout() {
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
        
        scrollContentView.addSubview(lineChartView)
        lineChartView.constraint(top: dayChartLabel.bottomAnchor,
                                 leading: dayChartLabel.leadingAnchor,
                                 trailing: infoBoxView.trailingAnchor,
                                 padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        lineChartView.constraint(lineChartView.heightAnchor, constant: 300)
        
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
        
        scrollContentView.addSubview(self.barChartView)
        barChartView.constraint(barChartView.heightAnchor, constant: 400)
        barChartView.constraint(
            top: weeklyChartLabel.bottomAnchor,
            leading: infoBoxView.leadingAnchor,
            bottom: scrollContentView.bottomAnchor,
            trailing: infoBoxView.trailingAnchor,
            padding: .init(top: 20, left: 0, bottom: 0, right: 0)
        )

    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func setupLineChartView() {
        self.lineChartView.setupLineChart(dataPoints: hours, values: dbValues)
        self.lineChartView.setupAverageLineChart(dataPoints: hours, values: dbValues)
    }
    
    private func setupBarChartView() {
        self.barChartView.setupBarChart(dataPoints: weekLabels, values: barDbValues)
    }
    
    private func setupNavigationBar() {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: leftOffsetBackButton)
        
        navigationItem.leftBarButtonItem = backButton
        
        title = locationName
    }
    
    private func makeBarButtonItem<T: UIView>(with view: T) -> UIBarButtonItem {
        return UIBarButtonItem(customView: view)
    }
    
    private func removeBarButtonItemOffset(with button: UIButton, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let offsetView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        offsetView.bounds = offsetView.bounds.offsetBy(dx: offsetX, dy: offsetY)
        offsetView.addSubview(button)
        return offsetView
    }
}
