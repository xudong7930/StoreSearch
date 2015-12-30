//
//  Search.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/29/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import Foundation
import UIKit

typealias SearchComplete = (Bool) -> Void

class Search {
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    
    var dataTask: NSURLSessionDataTask?
    
    
    // MARK: - CUSTOM FUNCTION
    func performSearchForText(text: String, category: Int, completion: SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel()
            
            isLoading = true
            hasSearched = true
            searchResults.removeAll()
            
            let url = urlWithSearchText(text, category: category)
            let session = NSURLSession.sharedSession()
            dataTask = session.dataTaskWithURL(url, completionHandler: {
                (data, response, error) -> Void in
                var success = false
                
                if let error2 = error {
                    if error2.code == -999 {
                        return // search canced
                    }
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let dictionary = self.parseJSON(data!) {
                            
                            self.searchResults = self.parseDictionary(dictionary)
                            
                            self.searchResults.sortInPlace({
                                $0.name.localizedCaseInsensitiveCompare($1.name) == .OrderedAscending
                            })
                            
                            self.isLoading = false
                            success = true
                            //return
                        }
                    }
                }
                
                if !success {
                
                    self.hasSearched = false
                    self.isLoading = false
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion(success)
                })
                
            })
            
            dataTask?.resume()
            
        }
    }
    
    
    func urlWithSearchText(searchText: String, category: Int) -> NSURL {
        var entityName = ""
        
        switch category {
        case 1:
            entityName = "musicTrack"
            
        case 2:
            entityName = "software"
            
        case 3:
            entityName = "ebook"
            
        default:
            entityName = ""
        }
        
        let searchText2 = searchText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let urlString = String(format: "http://itunes.apple.com/search?term=%@&limit=20&entity=%@", searchText2!, entityName)
        
        let url = NSURL(string: urlString)
        return url!
    }
    
    
    func parseJSON(data: NSData) -> [String: AnyObject]? {
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject]
            return json
        } catch let error as NSError {
            print("解析json出错: \(error.localizedDescription)")
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
        let result = SearchResult()
        
        result.name = dictionary["trackName"] as! String
        result.artistName = dictionary["artistName"] as! String
        result.artworkURL60 = dictionary["artworkUrl60"] as! String
        result.artworkURL100 = dictionary["artworkUrl100"] as! String
        result.storeURL = dictionary["trackViewUrl"] as! String
        result.kind = dictionary["kind"] as! String
        result.currency = dictionary["currency"] as! String
        
        
        if let price = dictionary["trackPrice"] as? NSNumber {
            result.price = Double(price)
        }
        
        if let genre = dictionary["primaryGenreName"] as? NSString {
            result.genre = genre as String
        }
        
        return result
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
    
}