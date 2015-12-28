//
//  UIImageView+DownloadImage.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/28/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import UIKit

extension UIImageView {

    func loadImageWithURL(url: NSURL) -> NSURLSessionDownloadTask {
        
        let session = NSURLSession.sharedSession()
        
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: {
            [weak self] (url, response, error) in
            
            if url != nil && error == nil {
            
                if let data = NSData(contentsOfURL: url!) {
                    if let image = UIImage(data: data) {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            if let strongSelf = self {
                                strongSelf.image = image
                            }
                        })
                    }
                    
                }
            }
        })
        
        downloadTask.resume()
        return downloadTask
    }
}
