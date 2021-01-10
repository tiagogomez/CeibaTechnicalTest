//
//  APIService.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 9/01/21.
//

import Foundation

protocol ServiceAPIProtocol {
  
  func getAllUsers(onComplete: @escaping ([UserData]) -> Void, onError: @escaping (Error) -> Void)
  func getPostsFrom(userId: Int, onComplete: @escaping ([PostData]) -> Void, onError: @escaping (Error) -> Void)
}

enum ServiceError: Error {
    case invalidURL
    case responseError
}

class APIService: ServiceAPIProtocol {
  
  private let baseURL = "https://jsonplaceholder.typicode.com"
  private let allUsersEndpoint = "/users"
  private let postsEndpoint = "/posts"
  
  func getAllUsers(onComplete: @escaping ([UserData]) -> Void,
                   onError: @escaping (Error) -> Void) {
    guard let url = URL(string: baseURL + allUsersEndpoint) else {
      onError(ServiceError.invalidURL)
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
      guard let data = data else {
        onError(ServiceError.responseError)
        return
      }
      
      do {
        let jsonDecoder = JSONDecoder()
        let userData = try jsonDecoder.decode([UserData].self, from: data)
        onComplete(userData)
      } catch {
        onError(error)
      }
    }.resume()
  }
  
  func getPostsFrom(userId: Int,
                    onComplete: @escaping ([PostData]) -> Void,
                    onError: @escaping (Error) -> Void) {
    let userIdValue = "?userId=\(String(userId))"
    guard let url = URL(string: baseURL + postsEndpoint + userIdValue) else {
      onError(ServiceError.invalidURL)
      return
    }
    
    URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
      guard let data = data else {
        onError(ServiceError.responseError)
        return
      }
      
      do {
        let jsonDecoder = JSONDecoder()
        let postsData = try jsonDecoder.decode([PostData].self, from: data)
        onComplete(postsData)
      } catch {
        onError(error)
      }
    }.resume()
  }
}
