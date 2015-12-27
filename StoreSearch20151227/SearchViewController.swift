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
    var searchResults = [SearchResult]()
    var hasSearched = false
    
    // MARK: - IBACTION ADN IBOUTLET
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - VIEW AND INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }
    
}


// MARK: - Searchbar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        hasSearched = true
        
        searchResults.removeAll()
        
        if searchBar.text?.lowercaseString != "jb" {

            for i in 0...2 {
                
                let singleSearch = SearchResult()
                singleSearch.name = String(format: "Fake data %d for", i)
                singleSearch.artistName = searchBar.text!
                
                searchResults.append(singleSearch)
            }
        }
    
        tableView.reloadData()
    }
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SearchResultCell"
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        
    
        if searchResults.count > 0 {
            let result = searchResults[indexPath.row]
            cell.textLabel!.text = result.name
            cell.detailTextLabel!.text = result.artistName
            
        } else {
            cell.textLabel!.text = "Nothing Found"
            cell.detailTextLabel!.text = ""
            
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hasSearched {
            if searchResults.count > 0 {
                return searchResults.count
            } else {
                return 1
            }
            
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return (searchResults.count > 0) ? indexPath : nil
    }
    
}


