//
//  VideoModel.swift
//  YouTubeApp
//
//  Created by Liam Kelly on 3/6/16.
//  Copyright © 2016 Liam Kelly. All rights reserved.
//

import UIKit
import Alamofire

// creating a protocol to pass dataReady to the viewController
protocol VideoModelDelegate {
    func dataReady()
}

class VideoModel: NSObject {
    
    let API_KEY = "AIzaSyAog73_vX9q3OovIMB9XVDDnb7oU_9TB-o"
    let UPLOADS_PLAYLIST_ID = "PLZHQObOWTQDPHP40bzkb0TKLRPwQGAoC-"
    var videoArray = [Video()]

    var delegate:VideoModelDelegate?
    
    
    func getFeedVideos() {

        // We don't want to set getFeedVideos to return an array of videos because we don't want our main thread to worry about fetching metadata. Alamofire is natively asynchronous, meaning we need to pass the array videos through a global variable and have this function return void
        
        Alamofire.request(.GET, "https://www.googleapis.com/youtube/v3/playlistItems", parameters: ["part":"snippet","playlistId":UPLOADS_PLAYLIST_ID,"key": API_KEY] , encoding: ParameterEncoding.URL, headers: nil).responseJSON {
            
            // Switch response to catch optional error, using Optional chaining with an if let statement doesn't work here for some reason - always returns with an optional = nil error
            response in switch response.result {
            case .Success(let JSON):
                print(JSON)
                // Create an array of videos to store our video object instances in
                var arrayOfVideos = [Video]()
                
                // Iterate through each item in our response at the level of the 'items' key
                for video in JSON["items"] as! NSArray {
                    
                    // Create video object off of the JSON response, each layer in valueForKeyPath represents a layer down in the JSON (snippet is wrapped around resource id, which is wrapped around videoId, which contains the info we want)
                    let videoObj = Video()
                    videoObj.videoId = video.valueForKeyPath("snippet.resourceId.videoId") as! String
                    videoObj.videoTitle = video.valueForKeyPath("snippet.title") as! String
                    videoObj.videoDescription = video.valueForKeyPath("snippet.description") as! String
                    
                    // Not all videos have a maxres thumbnail. If the maxres keyword returns nil, use 'high' instead.
                    
                    if let maxresurl = video.valueForKeyPath("snippet.thumbnails.maxres.url") as? String {
                        videoObj.videoThumbnailURL = maxresurl
                    } else if let highResURL = video.valueForKeyPath("snippet.thumbnails.high.url") as? String{
                        videoObj.videoThumbnailURL = highResURL
                    }
                    
                    // Add current videoObj instance to our array of videos
                    arrayOfVideos.append(videoObj)
                }
                
                // Set our newly created array of videos equal to the global array
                self.videoArray = arrayOfVideos
                
                // Notify the delegate that the data is ready
                if self.delegate != nil {
                    self.delegate!.dataReady()
                }

                
                // If Alamofire's response is nil, throw .Falure w/ an explanation
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        
    }
}
