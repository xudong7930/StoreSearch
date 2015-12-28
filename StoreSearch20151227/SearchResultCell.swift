//
//  SearchResultCell.swift
//  StoreSearch20151227
//
//  Created by xudong7930 on 12/27/15.
//  Copyright © 2015 xudong7930. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    // MARK: - VAR AND LET
    var downloadTask: NSURLSessionDownloadTask?
    
    // MARK: - IBACTION AND IBOUTLET
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    
    // MARK: - VIEW AND INIT
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        
        selectedBackgroundView = selectedView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
        downloadTask = nil
        
        nameLabel.text = ""
        artworkImageView.image = nil
        artistNameLabel.text = ""
    }
    
    
    // MARK: - CUSTOM FUNCTION 
    func configureForSearchResult(result: SearchResult) {
        nameLabel.text = result.name
        
        if result.artistName.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = String(format: "%@ (%@)", result.artistName, kindForDisplay(result.kind))
        }
        
        artworkImageView.image = UIImage(named: "Placeholder")
        if let url2 = NSURL(string: result.artworkURL60) {
            downloadTask = artworkImageView.loadImageWithURL(url2)
        }
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
