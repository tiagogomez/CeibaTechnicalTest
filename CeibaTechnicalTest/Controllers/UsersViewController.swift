//
//  UsersViewController.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 9/01/21.
//

import UIKit

class UsersViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView?

  var usersList: [UserData] = []
  var filteredUsers: [UserData] = []
  
  var apiService: ServiceAPIProtocol = APIService()
  var databaseManager: DatabaseProtocol = DatabaseManager()
  private let spinner = UIActivityIndicatorView(style: .medium)
  private let indicatorText = UILabel()
  private let searchController = UISearchController(searchResultsController: nil)

  private let userCellId = "UserDataCellId"
  private let postsViewControllerId = "PostsViewController"
  private let mainStoryboardId = "Main"
  
  private let navigationBarHeader = "Users List"
  private let indicatorLabelText = "Loading Users"
  private let indicatorLabelEmptyText = "List is empty"
  
  private var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  private var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchController()
    showLoadingIndicator()
    retrieveUsersDataIfNeeded()
    setupViewController()
  }
  
  private func showLoadingIndicator() {
    tableView?.isHidden = true
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.startAnimating()
    view.addSubview(spinner)
    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    indicatorText.text = indicatorLabelText
    indicatorText.sizeToFit()
    indicatorText.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(indicatorText)
    indicatorText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    indicatorText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
  }
  
  private func hideLoadingIndicator() {
    tableView?.isHidden = false
    spinner.stopAnimating()
    spinner.isHidden = true
    indicatorText.isHidden = true
  }
  
  func retrieveUsersDataIfNeeded() {
    guard let usersData = databaseManager.retrieveUsersData() else {
      getUserDataFromService()
      return
    }
    self.usersList = usersData
    DispatchQueue.main.async {
      self.tableView?.reloadData()
      self.hideLoadingIndicator()
    }
  }
  
  private func getUserDataFromService() {
    apiService.getAllUsers { list in
      self.usersList = list
      DispatchQueue.main.async {
        self.tableView?.reloadData()
        self.databaseManager.storeUserData(usersData: list)
        self.hideLoadingIndicator()
      }
    } onError: {_ in
      self.presentEmptyTableMessage()
    }
  }
  
  private func setupViewController() {
    self.title = navigationBarHeader
    let userDataCell = UserDataCellView()
    let cellNib = UINib(nibName: userDataCell.cellNibName, bundle: nil)
    tableView?.register(cellNib, forCellReuseIdentifier: userDataCell.cellIdentifier)
  }
  
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Users"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
  
  func filterContentForSearchText(_ searchText: String) {
    filteredUsers = usersList.filter({ (user) -> Bool in
      user.name.lowercased().contains(searchText.lowercased())
    })
    hideEmptyTableMessage()
    if isFiltering && filteredUsers.isEmpty {
      presentEmptyTableMessage()
    }
    tableView?.reloadData()
  }
  
  private func presentEmptyTableMessage() {
    tableView?.isHidden = true
    indicatorText.isHidden = false
    indicatorText.text = indicatorLabelEmptyText
  }
  
  private func hideEmptyTableMessage() {
    tableView?.isHidden = false
    indicatorText.isHidden = true
  }
  
}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isFiltering ? filteredUsers.count : usersList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as?  UserDataCellView else {
      return emptyCell(text: "Empty Cell")
    }
    let usersData = isFiltering ? filteredUsers: usersList
    cell.setupView(userData: usersData[indexPath.row], delegate: self)
    return cell
  }
  
  private func emptyCell(text: String) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = text
    return cell
  }
}

extension UsersViewController: UserDataCellProtocol {

  func showPostsButtonDidSelect(from user: UserData) {
    let storyBoard: UIStoryboard = UIStoryboard(name: mainStoryboardId, bundle: nil)
    guard let viewController = storyBoard.instantiateViewController(withIdentifier: postsViewControllerId) as? PostsViewController else {
      return
    }
    viewController.userData = user
    self.navigationController?.pushViewController(viewController, animated: false)
  }
}

extension UsersViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    guard let searchText = searchBar.text else {
      return
    }
    filterContentForSearchText(searchText)
  }
}
