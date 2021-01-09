//
//  PostCellView.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 9/01/21.
//

import UIKit
import Foundation

class PostCellView: UITableViewCell {
  
  @IBOutlet weak var postTitle: UILabel!
  @IBOutlet weak var postBody: UILabel!
  
  var cellIdentifier = "PostDataCellId"
  var cellNibName = "PostCellView"
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupView(postData: PostData) {
    postTitle.text = postData.title
    postBody.text = postData.body
    postTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
  }
}
