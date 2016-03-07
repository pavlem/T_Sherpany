//
//  AlbumVC.swift
//  Sherp
//
//  Created by Pavle Mijatovic on 63//16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//


import UIKit

class AlbumVC: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  var albumPhotosProperties = [AlbumPhotos]()
  var album = Album?()
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    getUserData()
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    self.navigationItem.title = album?.albumTitle
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  // MARK: - Properties
  private func getUserData() {
    
    
    let requestURL: NSURL = NSURL(string: photosForAlbumReqUrlString)!
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
          
          if let albumsJson = json as? [[String: AnyObject]] {
            for albumPhotos in albumsJson {

              if let idAlbum = albumPhotos["albumId"] as? Int? {
                if idAlbum == self.album?.albumID {
                  
                  if let id = albumPhotos["id"] as? Int? {
                    if let title = albumPhotos["title"] as? String {
                      if let url = albumPhotos["url"] as? String {
                        if let thumbUrl = albumPhotos["thumbnailUrl"] as? String {
                          
                          let albumPhotos = AlbumPhotos(id: id, title: title, url: url, thumbUrl: thumbUrl)
                          self.albumPhotosProperties.append(albumPhotos)
                          
                        }
                      }
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
extension AlbumVC: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return self.albumPhotosProperties.count
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("AlbumPhotoCell", forIndexPath: indexPath) as! AlbumPhotoCell
    
    let albumPhotoProperties = self.albumPhotosProperties[indexPath.row]
    
    cell.albumPhotoTitleImage.image = UIImage(named: "albumPhotoPlaceholder")
    cell.albumPhotoTitle.text = albumPhotoProperties.title
    cell.photoActivityIndicator.startAnimating()
    
    let urlRequest = NSURLRequest(URL: NSURL(string: albumPhotoProperties.thumbUrl!)!)
    let imageTask = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) {
      (data, response, error) -> Void in
      
      let imageForCell = UIImage(data: data!)
      dispatch_async(dispatch_get_main_queue(), {
        
        if let updateCell = tableView.cellForRowAtIndexPath(indexPath) as? AlbumPhotoCell {
          updateCell.albumPhotoTitleImage.image = imageForCell
          updateCell.photoActivityIndicator.stopAnimating()
        }
      })
    }
    
    imageTask.resume()
    
    return cell
  }
}

extension AlbumVC: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "ImageViewSegue") {
      
      let indexPath = self.tableView.indexPathForSelectedRow!
      let albumPhoto = self.albumPhotosProperties[indexPath.row]
      let imageVC = segue.destinationViewController as! ImageVC
      imageVC.imageUrl = albumPhoto.url!
    }
  }
}
