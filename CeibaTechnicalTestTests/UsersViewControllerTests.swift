//
//  UsersViewControllerTests.swift
//  CeibaTechnicalTestTests
//
//  Created by Santiago Gomez Giraldo on 10/01/21.
//

import XCTest
@testable import CeibaTechnicalTest

class UsersViewControllerTests: XCTestCase {
  
  var userViewController = UsersViewController()
  var mockDatabase = DatabaseMock()
  var mockService = ServiceMock()
  
  override func setUp() {
    userViewController.apiService = mockService
    userViewController.databaseManager = mockDatabase
  }
  
  func testRetrieveUsersDataIfNeeded_withLocalUserData_shouldReturnUserData() {
    //Setup
    let userData = [MockUserData.getMockUserData()]
    mockDatabase.storedUserData?.append(contentsOf: userData)
    
    //Test
    userViewController.retrieveUsersDataIfNeeded()
    
    //Verify
    XCTAssertEqual(userViewController.usersList, userData)
  }
  
  func testRetrieveUsersDataIfNeeded_withoutLocalUserData_shouldReturnUserDataFromService() {
    //Setup
    let userData = [MockUserData.getMockUserData()]
    mockService.userDataFromService = userData
    mockDatabase.storedUserData = nil
    
    //Test
    userViewController.retrieveUsersDataIfNeeded()
    
    //Verify
    XCTAssertEqual(userViewController.usersList, userData)
  }
  
  func testRetrieveUsersDataIfNeeded_withoutLocalAndServiceUserData_shouldNotReturnData() {
    //Setup
    mockService.userDataFromService = []
    mockDatabase.storedUserData = []
    
    //Test
    userViewController.retrieveUsersDataIfNeeded()
    
    //Verify
    XCTAssertEqual(userViewController.usersList, Array())
  }
  
  func testFilterContentForSearchText_withValidString_shoulReturnFilteredData() {
    //Setup
    let firstUser = MockUserData.getMockUserDataForUser(name: "User1")
    let secondUser = MockUserData.getMockUserDataForUser(name: "User2")
    let thirdUser = MockUserData.getMockUserDataForUser(name: "User3")
    let usersArray = [firstUser, secondUser, thirdUser]
    userViewController.usersList = usersArray
    
    //Test
    userViewController.filterContentForSearchText("1")
    
    //Verify
    XCTAssertEqual(userViewController.filteredUsers, [firstUser])
  }
  
  func testFilterContentForSearchText_withInvalidString_shoulReturnEmptyData() {
    //Setup
    let firstUser = MockUserData.getMockUserDataForUser(name: "User1")
    let secondUser = MockUserData.getMockUserDataForUser(name: "User2")
    let thirdUser = MockUserData.getMockUserDataForUser(name: "User3")
    let usersArray = [firstUser, secondUser, thirdUser]
    userViewController.usersList = usersArray
    
    //Test
    userViewController.filterContentForSearchText("0")
    
    //Verify
    XCTAssertEqual(userViewController.filteredUsers, Array())
  }
}
