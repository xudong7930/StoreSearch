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
        
        searchBar.becomeFirstResponder()
        
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        
        // register cell 1
        let cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        // register cell 2
        let cellNib2 = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib2, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    }
    
    
    // MARK: - CUSTOM FUNCTION
    func urlWithSearchText(searchText: String) -> NSURL {
        let searchText2 = searchText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let urlString = String(format: "http://itunes.apple.com/search?term=%@", searchText2!)
        
        let url = NSURL(string: urlString)
        
        return url!
    }
    
    
    func performSearchRequestWithURL(url: NSURL) -> String? {
        
        do {
            
            let resultString = try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
            return resultString
            
        } catch let error as NSError {
            print("search error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    
    func parseJSON(jsonString: String) -> [String: AnyObject]? {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options:.AllowFragments)
                return json as? [String : AnyObject]
            } catch let error as NSError {
                print("解析json出错: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
    
    
    func parseDictionary(dictionary: [String: AnyObject]) -> [SearchResult]{
        
        var searchResults = [SearchResult]()
        
        if let array: AnyObject = dictionary["results"] {
            for resultDict in array as! [AnyObject] {
                if let resultDict2 = resultDict as? [String: AnyObject] {
                    
                    var searchResult: SearchResult?
                    
                    
                    if let wrapperType = resultDict2["wrapperType"] as? NSString {
                        switch wrapperType {
                        case "track":
                            searchResult = parseTrack(resultDict2)
                            
                        case "audiobook":
                            searchResult = parseAudioBook(resultDict2)
                        
                        case "software":
                            searchResult = parseSoftware(resultDict2)
                            
                        default:
                            break
                        }
                    } else if let kind = resultDict2["kind"] as? String {
                        if kind == "ebook" {
                            searchResult = parseEBook(resultDict2)
                        }
                    }
                    
                    if let result = searchResult {
                        searchResults.append(result)
                    }
                }
            }
        }
        
        return searchResults
        
    }
    
    
    func parseTrack(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        
        searchResult.name = dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] as! String
        searchResult.kind = dictionary["kind"] as! String
        searchResult.currency = dictionary["currency"] as! String
        
        /*
        if let price = dictionary["trackPrice"] as? NSNumber {
            searchResult.price = Double(price)
        }
        */
        searchResult.price = Double(dictionary["trackPrice"] as! NSNumber)
        
        searchResult.genre = dictionary["primaryGenreName"] as! String
        
        return searchResult
    }
    
    
    func parseAudioBook(dictionary: [String: AnyObject]) -> SearchResult {
        let result = SearchResult()
        
        result.name = dictionary["collectionName"] as! String
        result.artistName = dictionary["artistName"] as! String
        result.artworkURL60 = dictionary["artworkUrl60"] as! String
        result.artworkURL100 = dictionary["artworkUrl100"] as! String
        result.storeURL = dictionary["collectionViewUrl"] as! String
        result.kind = "audiobook"
        result.currency = dictionary["currency"] as! String
        
        if let price = dictionary["collectionPrice"] as? NSNumber {
            result.price = Double(price)
        }
        
        if let genre = dictionary["primaryGenreName"] as? NSString {
            result.genre = genre as String
        }
        
        return result
    }
    
    
    func parseSoftware(dictionary: [String: AnyObject]) -> SearchResult {
        
        let result = SearchResult()
        
        result.name = dictionary["trackName"] as! String
        result.artistName = dictionary["artistName"] as! String
        result.artworkURL60 = dictionary["artworkUrl60"] as! String
        result.artworkURL100 = dictionary["artworkUrl100"] as! String
        result.storeURL = dictionary["trackViewUrl"] as! String
        result.kind = dictionary["kind"] as! String
        result.currency = dictionary["currency"] as! String
        
        if let price = dictionary["price"] as? NSNumber {
            result.price = Double(price)
        }
        
        if let genre = dictionary["primaryGenreName"] as? NSString {
            result.genre = genre as String
        }
        
        return result
    }
    
    
    func parseEBook(dictionary: [String: AnyObject]) -> SearchResult {
        
        let result = SearchResult()
        
        result.name = dictionary["trackName"] as! String
        result.artistName = dictionary["artistName"] as! String
        result.artworkURL60 = dictionary["artworkUrl60"] as! String
        result.artworkURL100 = dictionary["artworkUrl100"] as! String
        result.storeURL = dictionary["trackViewUrl"] as! String
        result.kind = dictionary["kind"] as! String
        
        if let price = dictionary["price"] as? NSNumber {
            result.price = Double(price)
        }
        
        if let genre = dictionary["genres"] as? NSString {
            result.genre = genre as String
        }
        
        return result
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Plearse try again.", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(ok)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func kindForDisplay(kind: String) -> String {
        var kind2 = ""
        switch kind {
        case "album" :
            kind2 = "Album"
            
        case "audiobook" :
            kind2 = "Audio Book"
            
        case "book" :
            kind2 = "Book"
        
        case "ebook" :
            kind2 = "E-Book"
        
        case "feature-movie" :
            kind2 = "Moview"
        
        case "music-video" :
            kind2 = "Music Video"
        
        case "podcast" :
            kind2 = "Podcast"
        
        case "software" :
            kind2 = "App"
        
        case "song" :
            kind2 = "Song"
            
        case "tv-episode" :
            kind2 = "TV Episode"
            
        default:
            kind2 = kind
        }
        
        return kind2
    }
}


// MARK: - Searchbar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            hasSearched = true
            searchResults.removeAll()
            
            let url = urlWithSearchText(searchBar.text!)
            
            if let jsonString = performSearchRequestWithURL(url) {
                if let dictionary = parseJSON(jsonString) {
                    
                    //print(dictionary)
                    searchResults = parseDictionary(dictionary)
                    
                    /*
                    searchResults.sortInPlace({
                        (result1, result2) -> Bool in
                        return result1.name.localizedStandardCompare(result2.name) == NSComparisonResult.OrderedAscending
                    })
                    */
                    searchResults.sortInPlace({
                        $0.name.localizedStandardCompare($1.name) == NSComparisonResult.OrderedAscending
                    })
                    
                    tableView.reloadData()
                    
                    return
                }
            }
            
            showNetworkError()
        
        }
        
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
            
            var artist = ""
            if result.artistName.isEmpty {
                artist = "Unknown"
            } else {
                artist = String(format: "%@ (%@)", result.artistName, kindForDisplay(result.kind))
            }
            
            cell.artistNameLabel!.text = artist
            
            
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


