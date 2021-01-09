//
//  APIService.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 9/01/21.
//

import Foundation

class APIService: NSObject {
  
  private let allUsersURL = "https://jsonplaceholder.typicode.com/users"
  private let postsFromUserURL = "https://jsonplaceholder.typicode.com/posts?userId="
  
  func getAllUsers(completion : @escaping ([UserData]) -> ()) {
    guard let url = URL(string: allUsersURL) else {
      return
    }
    URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
      if let data = data {
        let jsonDecoder = JSONDecoder()
        let userData = try! jsonDecoder.decode([UserData].self, from: data)
        completion(userData)
      }
    }.resume()
  }
  
  func getPostsFrom(userId: Int, completion: @escaping ([PostData]) -> ()) {
    guard let url = URL(string: postsFromUserURL + String(userId)) else {
      return
    }
    URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
      if let data = data {
        let jsonDecoder = JSONDecoder()
        let postsData = try! jsonDecoder.decode([PostData].self, from: data)
        completion(postsData)
      }
    }.resume()
  }
}
