//
//  ViewController.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 9/01/21.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!

  var usersList: [UserData] = []
  fileprivate let navigationBarHeader = "Users List"
  fileprivate let userCellId = "UserDataCellId"
  fileprivate let postsViewControllerId = "PostsViewController"
  fileprivate let mainStoryboardId = "Main"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    retrieveUsersData()
    setupViewController()
  }
  
  private func retrieveUsersData() {
    let apiService = APIService()
    apiService.getAllUsers { list in
      self.usersList = list
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  private func setupViewController() {
    self.title = navigationBarHeader
    let userDataCell = UserDataCellView()
    let cellNib = UINib(nibName: userDataCell.cellNibName, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: userDataCell.cellIdentifier)
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usersList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as?  UserDataCellView else {
      return emptyCell()
    }
    cell.setupView(userData: self.usersList[indexPath.row], delegate: self)
    return cell
  }
  
  private func emptyCell() -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "Empty Cell"
    return cell
  }
}

extension ViewController: UserDataCellProtocol {

  func showPostsButtonDidSelect(from user: UserData) {
    let storyBoard: UIStoryboard = UIStoryboard(name: mainStoryboardId, bundle: nil)
    guard let viewController = storyBoard.instantiateViewController(withIdentifier: postsViewControllerId) as? PostsViewController else {
      return
    }
    viewController.userData = user
    self.navigationController?.pushViewController(viewController, animated: false)
  }
}
