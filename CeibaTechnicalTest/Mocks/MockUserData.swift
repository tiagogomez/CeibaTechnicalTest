//
//  MockUserData.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 10/01/21.
//

import Foundation

class MockUserData {
  
  static func getMockUserData() -> UserData {
    return UserData(id: 5,
                    name: "mockUser",
                    username: "mockName",
                    email: "mockEmail",
                    phone: "123456789",
                    website: "mockSite.com")
  }
  
  static func getMockUserDataForUser(name: String) -> UserData {
    return UserData(id: 5,
                    name: name,
                    username: "mockName",
                    email: "mockEmail",
                    phone: "123456789",
                    website: "mockSite.com")
  }
  
  static func getMockPostData() -> PostData {
    return PostData(userId: 5,
                    id: 1,
                    title: "mockTitle",
                    body: "mockBody")
  }
}
