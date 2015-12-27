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
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
    }
    
    // MARK: - IBACTION ADN IBOUTLET
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - VIEW AND INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        
        // register cell 1
        let cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        // register cell 2
        let cellNib2 = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib2, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
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
        
        
    
        if searchResults.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
            
            let result = searchResults[indexPath.row]
            
            cell.nameLabel!.text = result.name
            cell.artistNameLabel!.text = result.artistName
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath) 
            
            return cell
        }
    
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


