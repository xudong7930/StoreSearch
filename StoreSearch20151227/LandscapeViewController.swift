//
//  LandscapeViewController.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/29/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {
    
    // MARK: - VAR AND LET
    var searchResults = [SearchResult]()
    var fistTime = true
    var downloadTasks = [NSURLSessionDownloadTask]()
    
    
    // MARK: - IBACTION AND IBOUTLET
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func pageChanged(sender: UIPageControl) {
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
            
                self.scrollView.contentOffset = CGPoint(
                    x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage),
                    y: 0)
            
            }, completion: nil)
    }
    
    
    // MARK: - VIEW AND INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        
        
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        
        pageControl.numberOfPages = 0
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        pageControl.frame = CGRect(
            x: 0,
            y: view.frame.size.height - pageControl.frame.size.height,
            width: view.frame.size.width,
            height: pageControl.frame.size.height
        )
        
        if fistTime {
            fistTime = false
            titleButtons(searchResults)
        }
    }
    
    deinit {
        for task in downloadTasks {
            task.cancel()
        }
    }
    
    
    // MARK: - CUSTOM FUNCTION
    func titleButtons(results: [SearchResult]) {
        var columnsPerPage = 5
        var rowsPerPage = 3
        var itemWidth: CGFloat = 96
        var itemHeight: CGFloat = 88
        var marginx: CGFloat = 0
        var marginy: CGFloat = 20
        
        let scrollViewWidth = scrollView.bounds.size.width
        
        switch scrollViewWidth {
        case 568: // for iphone5 device
            columnsPerPage = 6
            itemWidth = 94
            marginx = 2
        
        case 667: // for iphone6 device
            columnsPerPage = 7
            itemWidth = 95
            itemHeight = 98
            marginx = 1
            marginy = 29
            
        case 736: // for iphone6+ device
            columnsPerPage = 8
            rowsPerPage = 4
            itemWidth = 92
        
        default:
            break
        
        }
        
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth) / 2
        let paddingVert = (itemHeight - buttonHeight) / 2
        
        var row = 0
        var column = 9
        var x = marginx
        
        var i = 0
        for item in results {
            let button = UIButton(type: .Custom)
            downloadForSearchResult(item, andPlaceOnButton: button)
            
            button.frame = CGRect(
                x: x + paddingHorz,
                y: marginy + CGFloat(row) * itemHeight + paddingVert,
                width: buttonWidth,
                height: buttonHeight)
            
            
            scrollView.addSubview(button)
            
            ++row
            
            if row == rowsPerPage {
                row = 0
                ++column
                x += itemWidth
                
                if column == columnsPerPage {
                    column = 0
                    x += marginx * 2
                }
            }
            
        }
        
        let buttonPerpage = columnsPerPage * rowsPerPage
        let numPages = 1 + (searchResults.count - 1) / buttonPerpage
        
        scrollView.contentSize = CGSize(width: CGFloat(numPages) * scrollViewWidth, height: scrollView.bounds.height)
        
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
    }
    
    
    func downloadForSearchResult(result: SearchResult, andPlaceOnButton button: UIButton) {
        
        
        if let url = NSURL(string: result.artworkURL60) {
            let session = NSURLSession.sharedSession()
            let downloadTask = session.downloadTaskWithURL(url, completionHandler: {
                [weak button] (url, response, error) in
                if error == nil && url != nil {
                    if let data = NSData(contentsOfURL: url!) {
                        if let image = UIImage(data: data) {
                            dispatch_async(dispatch_get_main_queue(), {
                                if let button2 = button {
                                    button2.setImage(image, forState: .Normal)
                                }
                            })
                        }
                    }
                }
            })
            
            downloadTask.resume()
            downloadTasks.append(downloadTask)
        }
        
    }
}


extension LandscapeViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let currentPage = Int((scrollView.contentOffset.x + width/2) / width)
        
        pageControl.currentPage = currentPage
    }
}
