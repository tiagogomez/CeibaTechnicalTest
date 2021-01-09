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
  
  fileprivate var posts: [PostData] = []
  fileprivate let postSectionLabel = "Posts"
  fileprivate let navigationBarHeader = "User Info"
  fileprivate let postCellId = "PostDataCellId"
  
  var userData: UserData?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUserInfo()
    retrievePostsData()
    setupViewController()
  }
  
  private func retrievePostsData() {
    let apiService = APIService()
    guard let userId = userData?.id else {
      return
    }
    apiService.getPostsFrom(userId: userId) { posts in
      self.posts = posts
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
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
