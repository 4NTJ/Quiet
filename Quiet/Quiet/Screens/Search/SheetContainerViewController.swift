//
//  SheetContainerViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/25.
//

import UIKit

final class SheetContainerViewController: BaseViewController {
    
    // MARK: - Properties
    
    private lazy var detailTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(cell: LocationDetailTableViewCell.self)
        return tableView
    }()
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 4
        return view
    }()

    // MARK: - Func
    
    override func setupLayout() {
        view.addSubview(indicatorView)
        indicatorView.constraint(indicatorView.heightAnchor, constant: 4)
        indicatorView.constraint(indicatorView.widthAnchor, constant: 50)
        indicatorView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                 centerX: view.centerXAnchor,
                                 padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
        
        view.addSubview(detailTableView)
        detailTableView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                   leading: view.leadingAnchor,
                                   bottom: view.bottomAnchor,
                                   trailing: view.trailingAnchor,
                                   padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
    }
    
    override func configureUI() {
        super.configureUI()
        
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .init(width: 0, height: -2)
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.5
    }
}

// MARK: - UITableViewDataSource
extension SheetContainerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationDetailTableViewCell = tableView.dequeueReusableCell(withType: LocationDetailTableViewCell.self, for: indexPath)
        cell.setLocationData("안농")
        return cell
    }
}
