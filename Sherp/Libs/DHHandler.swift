//  
//  DHHandler.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

// Share Realm object across all Swift files
var uiRealm = try! Realm()
var userRealm = UserRealm()


class DBHandler {

  func getRealmConfiguration () {
    let config = Realm.Configuration()
    // Set as the configuration used for the default Realm
    Realm.Configuration.defaultConfiguration = config
  }
  
  // MARK: Write
  func clearAllData(){
    try! uiRealm.write {
      uiRealm.deleteAll()
    }
  }
  
  // MARK: - Private
  func update(dbObject: Object) {
    getRealmConfiguration()
    
    let realm = try! Realm()
    
    do {
      try realm.write {
        realm.add(dbObject, update: true)
        
      }
    } catch {
      self.dbAlertFeedback("DBAddingFailed")
    }
  }
  
  func add(dbObject: Object) {
    getRealmConfiguration()
    
    
    let realm = try! Realm()
    
    do {
      try realm.write {
        realm.add(dbObject)
      }
    } catch {
      self.dbAlertFeedback("DBAddingFailed")
    }
  }
  
  func delete(dbObject: Object) {
    getRealmConfiguration()
    
    let realm = try! Realm()
    
    do {
      try realm.write {
        realm.delete(dbObject)
      }
    } catch {
      self.dbAlertFeedback("DBDeletingFailed")
    }
  }
  
  func dbAlertFeedback(message: String) {
    self.dbAlertFeedback(title:"DBAlertTitle", message: message, buttonTitle: "DBAlertButtonTitle")
  }
  
  func dbAlertFeedback(title title:String, message:String, buttonTitle: String) {
    // TODO: Decide should any feedback exist. If not, delete statement down below.
    //        UIAlertController().alertUser(title, message: message, buttonTitle: buttonTitle)
  }
}