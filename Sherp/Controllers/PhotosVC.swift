//
//  PhotosVC.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class PhotosVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var album = Album?()
  

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    getUserData()
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    
  }
  
  // MARK: - Properties
  private func getUserData() {
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
extension PhotosVC: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 3
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath)
    
    cell.textLabel?.text = "sdfsdfsd"
    
    return cell
  }
}


extension PhotosVC: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  
//  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//    if (segue.identifier == "AlbumsSegue") {
//      
//      let indexPath = self.tableView.indexPathForSelectedRow!
//      let photosVC = segue.destinationViewController as! PhotosVC
//      
//      //      photosVC.album = self.albums[indexPath.row]
//    }
//  }
}