//
//  DetailViewController.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/28/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import UIKit
import MessageUI


class DetailViewControler: UIViewController {
    
    // MARK: - VIEW AND INIT
    var searchResult: SearchResult! {
        didSet {
            if isViewLoaded() {
                updateUI()
            }
        }
    }
    
    
    var downloadTask: NSURLSessionDownloadTask?
    var isPopUp = false
    
    
    enum AnimationStyle {
        case Slide
        case Fade
    }
    
    var dismissAnimationStyle = AnimationStyle.Fade
    
    
    
    // MARK: - IBACTION ADN IBOUTLET
    @IBAction func close() {
        dismissAnimationStyle = .Slide
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func openInStore() {
        if let url = NSURL(string: searchResult.storeURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    
    // MARK: - VIEW AND INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1.0)
        view.backgroundColor = UIColor.clearColor()
        
        popupView.layer.cornerRadius = 10
        

        if isPopUp {            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("close"))
            gestureRecognizer.cancelsTouchesInView = false
            gestureRecognizer.delegate = self
            
            view.addGestureRecognizer(gestureRecognizer)
            view.backgroundColor = UIColor.clearColor()
        } else {
            
            view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
            popupView.hidden = true
            
            if let displayName = NSBundle.mainBundle().localizedInfoDictionary?["CFBundleDisplayName"] as? NSString {
                title = displayName as String
            }
        }
        
        if searchResult != nil {
            updateUI()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .Custom
        
        transitioningDelegate = self
        
    }
    
    
    deinit {
        downloadTask?.cancel()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMenu" {
            let controller = segue.destinationViewController as! MenuViewController
            controller.delegate = self
        }
    }
    
    
    // MARK: - CUSTON FUNCTION
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artistName.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = searchResult.artistName
        }
        
        kindLabel.text = searchResult.kindForDisplay()
        genreLabel.text = searchResult.genre
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.currencyCode = searchResult.currency
        
        // config price button
        var priceText = ""
        if searchResult.price == 0 {
            priceText = "Free"
        } else if let text = formatter.stringFromNumber(searchResult.price) {
            priceText = text
        }
        
        priceButton.setTitle(priceText, forState: .Normal)
        
        // config image
        if let url2 = NSURL(string: searchResult.artworkURL100) {
            downloadTask = artworkImageView.loadImageWithURL(url2)
        }
        
        popupView.hidden = false
    }
}


// MARK: - UIVIEW TRANSITION DELEGATE
extension DetailViewControler: UIViewControllerTransitioningDelegate {
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch dismissAnimationStyle {
        case .Slide:
            return SlideOutAnimationController()
        case .Fade:
            return FadeOutAnimationController()
        }
        
    }
    
}


// MARK: - UIGesture Delegate
extension DetailViewControler: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return (view === touch.view)
    }
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
}


// MARK: - MenuViewController Delegate
extension DetailViewControler: MenuViewControllerDelegate {
    func MenuViewControllerSendSupportEmail(controller: MenuViewController) {
        
        if MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            
            controller.setSubject(NSLocalizedString("Support Request", comment: "Email subject"))
            controller.setToRecipients(["your@email-address-here.com"])
            
            controller.mailComposeDelegate = self
            controller.modalPresentationStyle = .FormSheet
            
            self.presentViewController(controller, animated: true, completion: nil)
            
        }
    }
}


// MARK: - MAIL 
extension DetailViewControler: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}