//
//  SearchViewController.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/24.
//

import CoreLocation
import MapKit
import UIKit

final class SearchViewController: UIViewController {
    
    private enum SearchType {
        case recentSearch, search, noResult
    }
    
    private enum Size {
        static let textFieldWidth = UIScreen.main.bounds.size.width - 64
        static let textFieldHeight = 44.0
        static let headerHeight = 66.0
        static let cellHeight = 56.0
    }
    
    // MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let button = BackButton()
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    private lazy var searchTextField: UITextField = {
        let textfield = UITextField(frame: CGRect(origin: .zero,
                                                  size: CGSize(width: Size.textFieldWidth, height: Size.textFieldHeight)))
        textfield.placeholder = "지역구 혹은 동을 입력해주세요"
        textfield.font = .systemFont(ofSize: 18, weight: .medium)
        textfield.borderStyle = .none
        textfield.clearButtonMode = .whileEditing
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.returnKeyType = .search
        textfield.delegate = self
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
        tableView.register(cell: SearchTableViewCell.self)
        return tableView
    }()
    
    private var tableViewBottomConstraint: NSLayoutConstraint?
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults: [MKLocalSearchCompletion] = []
    private var searchType: SearchType = .recentSearch
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNotificationCenter()
        setupSearchCompleter()
        setupNavigationBar()
    }
    
    // MARK: - Func
    
    private func setupLayout() {
        view.addSubview(separatorView)
        separatorView.constraint(separatorView.heightAnchor, constant: 5)
        separatorView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: .zero)
        
        view.addSubview(searchTableView)
        let constraint = searchTableView.constraint(top: separatorView.bottomAnchor,
                                                    leading: view.leadingAnchor,
                                                    bottom: view.bottomAnchor,
                                                    trailing: view.trailingAnchor,
                                                    padding: .zero)
        tableViewBottomConstraint = constraint[.bottom]
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    private func setupSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
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
    
    // MARK: - selector
    
    @objc
    private func keyboardWillShow(_ notification:NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.tableViewBottomConstraint?.constant = -keyboardHeight
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchType {
        case .recentSearch:
            return UserDefaultStorage.keywords.count
        default:
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchType {
        case .recentSearch:
            let cell: RecentKeywordTableViewCell = tableView.dequeueReusableCell(withType: RecentKeywordTableViewCell.self, for: indexPath)
            let keywords = Array(UserDefaultStorage.keywords.reversed())
            cell.setKeyword(to: keywords[indexPath.row])
            cell.didTappedRemove = { [weak self] keyword in
                UserDefaultHandler.clearKeyword(keyword: keyword)
                self?.searchTableView.reloadData()
            }
            return cell
        default:
            let cell: SearchTableViewCell = tableView.dequeueReusableCell(withType: SearchTableViewCell.self, for: indexPath)
            cell.setKeyword(to: searchResults[indexPath.row].title)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch searchType {
        case .recentSearch:
            let headerView = RecentKeywordHeaderView()
            headerView.didTappedClearAll = { [weak self] in
                UserDefaultHandler.clearAllKeywords()
                self?.searchTableView.reloadData()
            }
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch searchType {
        case .recentSearch:
            return Size.headerHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.tableViewBottomConstraint?.constant = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let keyword = textField.text else { return false }
        UserDefaultHandler.setKeywords(keyword: keyword)
        searchTableView.reloadData()
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text, searchText != "" else {
            searchType = .recentSearch
            searchTableView.reloadData()
            return
        }
        
        searchType = .search
        searchCompleter.queryFragment = searchText
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results.filter { result in
            let splitTitle = result.title.split(separator: " ")
            guard splitTitle.count > 1 else { return false }
            return splitTitle.contains("서울특별시")
        }
        searchTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
