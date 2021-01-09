//
//  UserDataCellView.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 9/01/21.
//

import UIKit
import Foundation

protocol UserDataCellProtocol {
  
  func showPostsButtonDidSelect(from user: UserData)
}

class UserDataCellView: UITableViewCell {

  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var userPhone: UILabel!
  @IBOutlet weak var userEmail: UILabel!
  @IBOutlet weak var showPostsButton: UIButton!
  
  var cellIdentifier = "UserDataCellId"
  var cellNibName = "UserDataCellView"
  
  var userData: UserData?
  var delegate: UserDataCellProtocol?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupView(userData: UserData, delegate: UserDataCellProtocol) {
    userName.text = userData.name
    userPhone.text = userData.phone
    userEmail.text = userData.email
    self.delegate = delegate
    self.userData = userData
  }
  
  @IBAction func showPostsButtonPressed(_ sender: Any) {
    guard let userData = self.userData else {
      return
    }
    delegate?.showPostsButtonDidSelect(from: userData)
  }
}
