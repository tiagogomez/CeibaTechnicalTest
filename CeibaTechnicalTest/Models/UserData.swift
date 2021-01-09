//
//  UserData.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 9/01/21.
//

import Foundation

struct UserData: Decodable {

  let id: Int
  let name: String
  let username: String
  let email: String
  let phone: String
  let website: String
}
