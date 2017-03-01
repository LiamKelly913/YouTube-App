//
//  ViewController.swift
//  YouTubeApp
//
//  Created by Liam Kelly on 3/6/16.
//  Copyright © 2016 Liam Kelly. All rights reserved.
//

import UIKit

// set viewcontroller as a subclass of proper classes, including videomodeldelegate
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    var videos:[Video] = [Video]()
    var selectedVideo:Video?
    
    // Create new video model object
    let model:VideoModel = VideoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set the viewcontroller as the delegate of the model
        self.model.delegate = self
        
        
        // Fire off request to get videos
        model.getFeedVideos()
        
        
        self.tableView.dataSource = self
        
        // setting the view controller as the delegate of the tableview, when an event occurs on the tableview, it notifies the view controller
        self.tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    // MARK: - Video Model Delegate Methods, needed by VideoModel for ViewController to be a delegate
    
    
    func dataReady(){
        
        // Access the video objects that have been downloaded 
        self.videos = self.model.videoArray
        
        // Tell the tableview to reload
        self.tableView.reloadData()
        
    }
    
    
    
    
    // MARK: - TableView Delegate Methods
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                // get width of the screen to calculate the height of the row
        return (self.view.frame.size.width / 320) * 180
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videos.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        
        let videoTitle = videos[(indexPath as NSIndexPath).row].videoTitle
        
        // Get the label for the cell
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        // Construct the video thumbnail url
        let videoThumbnailURLString = videos[(indexPath as NSIndexPath).row].videoThumbnailURL
        
        // Create an NSURL object
        let videoThumbnailURL = URL(string: videoThumbnailURLString)
        
        if videoThumbnailURL != nil {
            
            // Create an NSURLRequest object
            let request = URLRequest(url: videoThumbnailURL!)
        
            // Create an NSURLSession
            let session = URLSession.shared
            
            // Create a datatask and pass in the request, tells us what to do when the data has been grabbed
            let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                
                //Forces the code to render view image to move to the main thread instead of rendering in the background, not asynchronous
                DispatchQueue.main.async(execute: { () -> Void in
                    // Get a reference to the imageview element of the cell
                    let imageView = cell.viewWithTag(1) as! UIImageView
                    
                    // Create an image object from the data and assign it to Image View
                    if UIImage(data:data!) != nil {
                    imageView.image = UIImage(data: data!)
                    }
                })
                
                
            } as! (Data?, URLResponse?, Error?) -> Void)
            
            dataTask.resume()
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Take note of which video user selected
        self.selectedVideo = self.videos[(indexPath as NSIndexPath).row]
        
        // Call the segue
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    
    // Pass video over when segue is about to happen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        // Get a reference to the destination view controller
        let detailViewController = segue.destination as! VideoDetailViewController
        
        
        // Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
    }
    
    
    
    
    
}

