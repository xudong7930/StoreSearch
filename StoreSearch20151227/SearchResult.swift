//
//  SearchResult.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/27/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import Foundation

class SearchResult {
    
    // MARK: - VAR AND LET
    var name = ""
    var artistName = ""
    var artworkURL60 = ""
    var artworkURL100 = ""
    var storeURL = ""
    var kind = ""
    var currency = ""
    var price = 0.0
    var genre = ""

    // MARK: - CUSOTM FUNCTION
    func kindForDisplay() -> String {
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