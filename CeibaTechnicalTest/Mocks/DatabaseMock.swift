//
//  DatabaseMock.swift
//  CeibaTechnicalTestTests
//
//  Created by Santiago Gomez Giraldo on 10/01/21.
//

import Foundation

class DatabaseMock: DatabaseProtocol {
  
  var storedUserData: [UserData]? = []
  
  func storeUserData(usersData: [UserData]) {
    let mockUserData = MockUserData.getMockUserData()
    storedUserData?.append(mockUserData)
  }
  
  func retrieveUsersData() -> [UserData]? {
    return storedUserData
  }
}
