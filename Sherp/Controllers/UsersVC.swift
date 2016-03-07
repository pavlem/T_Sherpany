//
//  UsersVC.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class UsersVC: UITableViewController {
  
  // MARK: - Properties
  var users = [User]()
  var filteredUsers = [User]()
  let searchController = UISearchController(searchResultsController: nil)
  var usersForDB = [UserRealm]()
  

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    setupSearchController()
    setupTableView()
    getUserData()
    setLocalizedLabels()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    //    self.sesionTask.cancel()
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  // MARK: - Private
  private func setLocalizedLabels() {
    self.navigationItem.title = "users".localized()
  }
  
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.searchBar.delegate = self
    definesPresentationContext = true
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.scopeButtonTitles = nil;
    tableView.tableHeaderView = searchController.searchBar
  }
  
  private func getUserData() {
    let isKeyInDB = DEFAULTS.objectForKey(userDefaultsKey_dbHasUsers) as! String
    
    if isKeyInDB == "true" {
      print("is in DB")
      getUserDataFromDB()
    } else {
      print("not in db")
      getUserDataFromServer()
    }
  }
  
  private func getUserDataFromDB() {
    
    let usersFromRealm = uiRealm.objects(UserRealm)
    
    for userInRealm in usersFromRealm {
      let user = User(userId: userInRealm.userId, name: userInRealm.name, email: userInRealm.email, coCatchPhrase: userInRealm.coCatchPhrase)
      self.users.append(user)
    }
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false

  }
  
  private func getUserDataFromServer() {
    
    let requestURL: NSURL = NSURL(string: usersReqUrlString)!
    let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
    let sesionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
    sesionConfig.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
    let session = NSURLSession(configuration: sesionConfig)
    let task = session.dataTaskWithRequest(urlRequest) {
      (data, response, error) -> Void in
      
      let httpResponse = response as! NSHTTPURLResponse
      let statusCode = httpResponse.statusCode
      
      if (statusCode == 200) {
        
        do{
          
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          
          let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
          
          if let usersJson = json as? [[String: AnyObject]] {
            for user in usersJson {
              
              if let idUser = user["id"] as? Int? {
                if let name = user["name"] as? String {
                  if let email = user["email"] as? String {
                    if let company = user["company"] as? [String : AnyObject]  {
                      if let catchPhrase = company["catchPhrase"] as? String {
                        let user = User(userId: idUser, name: name, email: email, coCatchPhrase: catchPhrase)
                        
                        let userForRealm = UserRealm()
                        userForRealm.name = name
                        userForRealm.email = email
                        userForRealm.coCatchPhrase = catchPhrase
                        userForRealm.userId = idUser!
                        self.usersForDB.append(userForRealm)
                        self.users.append(user)
                      }
                    }
                  }
                }
              }
            }
            
            self.saveUsersToDB()
            
            dispatch_async(dispatch_get_main_queue(), {
              self.tableView.reloadData()
            })
          }
          
        } catch {
          print("Error with Json: \(error)")
          
        }
      }
    }
    
    task.resume()
  }
  
  private func saveUsersToDB() {
    
    for userR in self.usersForDB {
      DBHandler().add(userR)
    }
    DEFAULTS.setObject("true", forKey: userDefaultsKey_dbHasUsers)
  }
  
  private func setupTableView() {
    tableView.estimatedRowHeight = 68.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView(frame: CGRectZero)
    tableView.tableFooterView!.hidden = true
    tableView.backgroundColor = UIColor.whiteColor()
  }
  
  
  // MARK: - Delegates
  // MARK: UITableViewDataSource
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.active && searchController.searchBar.text != "" {
      return filteredUsers.count
    }
    return self.users.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
    var user = users[indexPath.row]
    
    if searchController.active && searchController.searchBar.text != "" {
      user = filteredUsers[indexPath.row]
    } else {
      user = users[indexPath.row]
    }
    cell.name.text = user.name
    cell.email.text = user.email
    cell.coCatchPhrase.text = user.coCatchPhrase
    
    return cell
  }
  
  // MARK:  UITableViewDelegate Methods
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "AlbumsSegue") {
      let indexPath = self.tableView.indexPathForSelectedRow!
      let albumsVC = segue.destinationViewController as! AlbumsVC
      
      if searchController.active && searchController.searchBar.text != "" {
        albumsVC.user = self.filteredUsers[indexPath.row]
      } else {
        albumsVC.user = self.users[indexPath.row]
      }
    }
  }
  
  func filterContentForSearchText(searchText: String) {
    filteredUsers = users.filter({( user : User) -> Bool in
      return user.name!.lowercaseString.containsString(searchText.lowercaseString)
    })
    tableView.reloadData()
  }
}

// MARK: - Extensions
// MARK: UISearchResultsUpdating Delegate
extension UsersVC: UISearchBarDelegate {
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!)
  }
}

// MARK: UISearchResultsUpdating Delegate
extension UsersVC: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}