//
//  AlbumsVC.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class AlbumsVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var albums = [Album]()
  var user = User?()
//  var sesionTask = NSURLSessionDataTask()

  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    getUserData()
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    self.navigationItem.title = user?.name

  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
//    self.sesionTask.cancel()
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  // MARK: - Properties
  private func getUserData() {
    
    let requestURL: NSURL = NSURL(string: albumsReqUrlString)!
    let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
    
    let sesionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
    sesionConfig.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
    //    let session = NSURLSession.sharedSession()
    let session = NSURLSession(configuration: sesionConfig)
    
    
    let task = session.dataTaskWithRequest(urlRequest) {
      (data, response, error) -> Void in
      
      let httpResponse = response as! NSHTTPURLResponse
      let statusCode = httpResponse.statusCode
      
      if (statusCode == 200) {
        
        do{
          
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          
          let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
          
          if let albumsJson = json as? [[String: AnyObject]] {
            for album in albumsJson {
              
              if let idUser = album["userId"] as? Int? {
                if idUser == self.user?.userId {
                  
                  if let id = album["id"] as? Int? {
                    if let title = album["title"] as? String {
                      
                      let album = Album(albumID: id, albumTitle: title)
                      self.albums.append(album)
                      
                    }
                  }
                }
              }
              

            }
            
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
//    self.sesionTask = task

  }
  
  private func setupTableView() {
    // Table view itself
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 68.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView(frame: CGRectZero)
    tableView.tableFooterView!.hidden = true
    tableView.backgroundColor = UIColor.whiteColor()
  }
}


// MARK: - Extensions
// MARK: UITableViewDataSource
extension AlbumsVC: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.albums.count
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath)
    
    cell.textLabel?.text = self.albums[indexPath.row].albumTitle
    
    return cell
  }
}


extension AlbumsVC: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "AlbumSegue") {
 
      let indexPath = self.tableView.indexPathForSelectedRow!
      let albumVC = segue.destinationViewController as! AlbumVC
      albumVC.album = self.albums[indexPath.row]
    }
  }
}

