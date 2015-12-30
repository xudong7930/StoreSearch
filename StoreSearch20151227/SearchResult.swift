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
            kind2 = NSLocalizedString("Album", comment: "Localized kind: Album")
            
        case "audiobook" :
            kind2 = NSLocalizedString("Audio Book", comment: "Localized kind: Audio Book")
            
        case "book" :
            kind2 = NSLocalizedString("Book", comment: "Localized kind: Book")
            
        case "ebook" :
            kind2 = NSLocalizedString("E-Book", comment: "Localized kind: E-Book")
            
        case "feature-movie" :
            kind2 = NSLocalizedString("Moview", comment: "Localized kind: Feature Movie")
            
        case "music-video" :
            kind2 = NSLocalizedString("Music Video", comment: "Localized kind: Music Video")
            
        case "podcast" :
            kind2 = NSLocalizedString("Podcast", comment: "Localized kind: Podcast")
            
        case "software" :
            kind2 = NSLocalizedString("App", comment: "Localized kind: Software")
            
        case "song" :
            kind2 = NSLocalizedString("Song", comment: "Localized kind: Song")
            
        case "tv-episode" :
            kind2 = NSLocalizedString("TV Episode", comment: "Localied kind: TV Episode")
            
        default:
            kind2 = kind
        }
        
        return kind2
    }
}