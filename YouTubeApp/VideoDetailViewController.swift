//
//  VideoDetailViewController.swift
//  YouTubeApp
//
//  Created by Liam Kelly on 3/7/16.
//  Copyright © 2016 Liam Kelly. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var selectedVideo:Video?

    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Pass data here because we don't know the dimensions of the view until this point (don't know it at viewDidLoad)
    override func viewDidAppear(_ animated: Bool) {
        if let vid = self.selectedVideo {
            self.titleLabel.text = vid.videoTitle
            self.descriptionLabel.text = vid.videoDescription
            
            let width = self.view.frame.size.width
            let height = width/320 * 180
            
            //Adjust the height of the web view for corresponding video
             self.webViewHeightConstraint.constant = CGFloat(height)
            
            
            
            // Grab video url w/ html for iFrame
            let videoEmbedString = "<html><head><style type=\"text/css\">body {background-color: transparent;color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder=\"0\" height=\"" + String(describing: height) + "\"width=\"" + String(describing: width) + "\" src=\"http://www.youtube.com/embed/" + vid.videoId + "?showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
            self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
        }
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
