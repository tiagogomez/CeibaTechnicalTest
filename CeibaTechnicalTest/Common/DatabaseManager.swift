//
//  DatabaseManager.swift
//  CeibaTechnicalTest
//
//  Created by Santiago Gomez Giraldo on 9/01/21.
//

import CoreData
import UIKit

class DatabaseManager {
  
  private let entityName = "UserInfo"
  private let idKey = "id"
  private let nameKey = "name"
  private let usernameKey = "username"
  private let emailKey = "email"
  private let phoneKey = "phone"
  private let websiteKey = "website"
  
  func storeUserData(usersData: [UserData]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    for user in usersData {
      guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else {
        return
      }
      let newUser = NSManagedObject(entity: entity, insertInto: managedContext)
      newUser.setValue(user.id, forKeyPath: idKey)
      newUser.setValue(user.name, forKeyPath: nameKey)
      newUser.setValue(user.username, forKeyPath: usernameKey)
      newUser.setValue(user.email, forKeyPath: emailKey)
      newUser.setValue(user.phone, forKeyPath: phoneKey)
      newUser.setValue(user.website, forKeyPath: websiteKey)
    }
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
  
  func retrieveUsersData() -> [UserData]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    
    do {
      let users = try managedContext.fetch(fetchRequest)
      guard !users.isEmpty else {
        return nil
      }
      
      return managedObjectToUserData(users)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return nil
    }
  }
  
  private func managedObjectToUserData(_ managedObject: [NSManagedObject]) -> [UserData]? {
    var usersData: [UserData] = []
    for user in managedObject {
      guard let id = user.value(forKey: idKey) as? Int,
            let name = user.value(forKey: nameKey) as? String,
            let username = user.value(forKey: usernameKey) as? String,
            let email = user.value(forKey: emailKey) as? String,
            let phone = user.value(forKey: phoneKey) as? String,
            let website = user.value(forKey: websiteKey) as? String else {
        return nil
      }
      usersData.append(UserData(id: id,
                                 name: name,
                                 username: username,
                                 email: email,
                                 phone: phone,
                                 website: website))
    }
    return usersData
  }
}
