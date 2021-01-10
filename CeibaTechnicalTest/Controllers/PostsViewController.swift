//
//  PostsViewController.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 9/01/21.
//

import UIKit
import Foundation

class PostsViewController: UIViewController {
  
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userEmail: UILabel!
  @IBOutlet weak var userPhone: UILabel!

  @IBOutlet weak var tableView: UITableView!
  
  var userData: UserData?
  var apiService: ServiceAPIProtocol = APIService()
  
  private let spinner = UIActivityIndicatorView(style: .medium)
  private let indicatorText = UILabel()
  private let indicatorLabelText = "Loading Posts"
  private let indicatorLabelEmptyText = "List is empty"
  
  private var posts: [PostData] = []
  private let postSectionLabel = "Posts"
  private let navigationBarHeader = "User Info"
  private let postCellId = "PostDataCellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    showLoadingIndicator()
    setupUserInfo()
    retrievePostsData()
    setupViewController()
  }
  
  private func retrievePostsData() {
    guard let userId = userData?.id else {
      return
    }
    apiService.getPostsFrom(userId: userId) { posts in
      self.posts = posts
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.hideLoadingIndicator()
      }
    } onError: {_ in
      self.presentEmptyTableMessage()
    }
  }
  
  private func showLoadingIndicator() {
    tableView.isHidden = true
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
    tableView.isHidden = false
    spinner.stopAnimating()
    spinner.isHidden = true
    indicatorText.isHidden = true
  }
  
  private func setupViewController() {
    self.title = navigationBarHeader
    userName.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
    let postDataCell = PostCellView()
    let cellNib = UINib(nibName: postDataCell.cellNibName, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: postDataCell.cellIdentifier)
  }
  
  private func setupUserInfo() {
    userName.text = userData?.name
    userEmail.text = userData?.email
    userPhone.text = userData?.phone
  }
  
  private func presentEmptyTableMessage() {
    tableView.isHidden = true
    indicatorText.isHidden = false
    indicatorText.text = indicatorLabelEmptyText
  }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: postCellId, for: indexPath) as? PostCellView else {
      return emptyCell()
    }
    cell.setupView(postData: posts[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return postSectionLabel
  }
  
  private func emptyCell() -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "Empty Cell"
    return cell
  }
}
