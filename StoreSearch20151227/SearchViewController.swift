//
//  ViewController.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/27/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - VAR AND LET
    let search = Search()
    
    var landscapeViewController: LandscapeViewController?
    
    weak var splitViewDetail: DetailViewControler?
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
    
    // MARK: - IBACTION ADN IBOUTLET
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        performSearch()
    
    }
    
    
    // MARK: - VIEW AND INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.becomeFirstResponder()
        
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        
        // register cell 1
        let cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        // register cell 2
        let cellNib2 = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib2, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        // register cell 3
        let cellNib3 = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib3, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        title = NSLocalizedString("Search", comment: "Split-view master button")
        
        if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
            searchBar.becomeFirstResponder()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  
        if segue.identifier == "ShowDetail" {
            
            switch search.state {
            case .Results(let list):
                
                let detailViewController = segue.destinationViewController as! DetailViewControler
                let indexPath = sender as! NSIndexPath
                let result = list[indexPath.row]
                
                detailViewController.searchResult = result
                detailViewController.isPopUp = true
                
            default:
                break
            }

        }
    }
    
    
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        
        switch newCollection.verticalSizeClass {
        case .Compact:
            showLandscapeViewWithCoordinator(coordinator)
            
        case .Regular, .Unspecified:
            hideLandscapeViewWithCoordinator(coordinator)
        }
    }
    
    
    
    // MARK: - CUSTOM FUNCTION
    func hideMasterPane() {
        UIView.animateWithDuration(0.25, animations: {
                self.splitViewController!.preferredDisplayMode = .PrimaryHidden
            }, completion: {
            _ in
            self.splitViewController?.preferredDisplayMode = .Automatic
        })
    }
    
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Plearse try again.", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(ok)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func showLandscapeViewWithCoordinator(coordinator: UIViewControllerTransitionCoordinator) {
        
        precondition(landscapeViewController == nil)
        
        landscapeViewController = storyboard!.instantiateViewControllerWithIdentifier("LandscapeViewController") as? LandscapeViewController
        
        if let controller = landscapeViewController {
            controller.search = search
            
            controller.view.frame = view.bounds
            controller.view.alpha = 0
            
            view.addSubview(controller.view)
            
            addChildViewController(controller)
            
            coordinator.animateAlongsideTransition({
                _ in
                    controller.view.alpha = 1
                
                    if self.presentedViewController != nil {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                
                    self.searchBar.resignFirstResponder()
                }, completion: {
                _ in
                    controller.didMoveToParentViewController(self)
            })
        }
        
        
    }
    
    func hideLandscapeViewWithCoordinator(coordinator: UIViewControllerTransitionCoordinator) {
        if let controller = landscapeViewController {
            controller.willMoveToParentViewController(nil)
            
            coordinator.animateAlongsideTransition({
                _ in
                    controller.view.alpha = 0
                
                    if self.presentedViewController != nil {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                
                }, completion: {
                _ in
                    controller.view.removeFromSuperview()
                    controller.removeFromParentViewController()
                    self.landscapeViewController = nil
            })
        
        }
    }
}


// MARK: - Searchbar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSearch()
    }
    

    func performSearch() {
        if let category = Search.Category(rawValue: segmentControl.selectedSegmentIndex) {
            search.performSearchForText(searchBar.text!, category: category, completion: {
                (success) in
                
                if !success {
                    self.showNetworkError()
                }
                
                self.tableView.reloadData()
                
                
                if let controller = self.landscapeViewController {
                    controller.searchResultsReceived()
                }
                
            })
            
            tableView.reloadData()
            searchBar.resignFirstResponder()
        }
    }
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch search.state {
        case .NotSearchYet:
            fatalError("Should never get here")
            
        case .Loading:
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath: indexPath)
            
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            
            return cell
            
        case .NoResults:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
            
            return cell
            
        case .Results(let lists):
            
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
            
            let result = lists[indexPath.row]
            
            cell.configureForSearchResult(result)
            
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch search.state {
        case .NotSearchYet:
            return 0
        
        case .Loading, .NoResults:
            return 1
        
        case .Results(let list):
            return list.count
            
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if view.window!.rootViewController!.traitCollection.horizontalSizeClass
            == .Compact {
        
                performSegueWithIdentifier("ShowDetail", sender: indexPath)
        
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            switch search.state {
            case .Results(let list):
                splitViewDetail?.searchResult = list[indexPath.row]
                
            default:
                break
            }
            
            if splitViewController!.displayMode != .AllVisible {
                hideMasterPane()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        switch search.state {
        case .NotSearchYet, .Loading, .NoResults:
            return nil
        
        case .Results:
            return indexPath
        }
    }
    
}


