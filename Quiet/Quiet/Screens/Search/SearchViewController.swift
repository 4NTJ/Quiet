//
//  SearchViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private enum Size {
        static let textFieldWidth = UIScreen.main.bounds.size.width - 64
        static let textFieldHeight = 44.0
        static let headerHeight = 66.0
        static let cellHeight = 56.0
    }
    
    // MARK: - properties
    
    private lazy var backButton: UIButton = {
        let button = BackButton()
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    private let searchTextField: UITextField = {
        let textfield = UITextField(frame: CGRect(origin: .zero,
                                                  size: CGSize(width: Size.textFieldWidth, height: Size.textFieldHeight)))
        textfield.placeholder = "지역구 혹은 동을 입력해주세요"
        textfield.font = .systemFont(ofSize: 18, weight: .medium)
        textfield.borderStyle = .none
        textfield.clearButtonMode = .whileEditing
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.returnKeyType = .search
        return textfield
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = .zero
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: RecentKeywordTableViewCell.self)
        return tableView
    }()
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationBar()
    }
    
    // MARK: - func
    
    private func setupLayout() {
        view.addSubview(separatorView)
        separatorView.constraint(separatorView.heightAnchor, constant: 5)
        separatorView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: .zero)
        
        view.addSubview(searchTableView)
        searchTableView.constraint(top: separatorView.bottomAnchor,
                                   leading: view.leadingAnchor,
                                   bottom: view.bottomAnchor,
                                   trailing: view.trailingAnchor,
                                   padding: .zero)
    }
    
    private func setupNavigationBar() {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 10)
        let backButton = makeBarButtonItem(with: leftOffsetBackButton)
        let searchTextField = makeBarButtonItem(with: searchTextField)
        
        navigationItem.leftBarButtonItems = [backButton, searchTextField]
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

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaultStorage.keywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecentKeywordTableViewCell = tableView.dequeueReusableCell(withType: RecentKeywordTableViewCell.self, for: indexPath)
        cell.setKeyword(to: UserDefaultStorage.keywords[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RecentKeywordHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Size.headerHeight
    }
}
