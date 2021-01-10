//
//  ServiceMock.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 10/01/21.
//

import Foundation

class ServiceMock: ServiceAPIProtocol {
  
  var userDataFromService: [UserData] = []
  
  func getAllUsers(onComplete: @escaping ([UserData]) -> Void,
                   onError: @escaping (Error) -> Void) {
    onComplete(userDataFromService)
  }
  
  func getPostsFrom(userId: Int, onComplete: @escaping ([PostData]) -> Void, onError: @escaping (Error) -> Void) {
    onComplete([MockUserData.getMockPostData()])
  }
  
  
}
