//
//  PostData.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 9/01/21.
//

import Foundation

struct PostData: Decodable {

  let userId: Int
  let id: Int
  let title: String
  let body: String
}
