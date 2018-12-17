//
//  MusicViewModel.swift
//  SignedInTunes
//
//  Created by Kevin Yu on 12/17/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

import Foundation

@objcMembers
class MusicViewModel {
    
    // have an array albums
    private var albums = [Album]()
    
    var numberOfAlbums: Int {
        return albums.count
    }
    
    // have webservicemanager
    
    // download data
    func getAlbums(_ completion: @escaping ()->Void) {
        WebserviceManager.sharedInstance().getAlbums { [weak self] (albumDict) in
            // parse
            let albums = self?.parseAlbumsFromDict(albumDict as! [String : Any])
            
            self?.albums = albums ?? []
            // send data back to the vc
            completion()
        }
    }
    
    func titleForAlbum(_ index: Int) -> String {
        if index >= self.numberOfAlbums || index < 0 {
            print("Warning: Went out of bounds for available items.")
            return "Unknown Title"
        }
        return self.albums[index].albumName ?? "Unknown Title"
    }
    
    
    private func parseAlbumsFromDict(_ dict: [String:Any]) -> [Album] {
        guard let feedDict = dict["feed"] as? [String:Any] else { return [] }
        guard let entries = dict["entry"] as? [[String:Any]] else { return [] }
        guard entries.count > 0 else { return [] }
        
        var dictAlbums = [Album]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-ddThh:mm:ss.nnnnnn+|-hh:mm"
        
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        
        func getValueOfAny(_ any: Any?) -> [String:String]? {
            if any == nil { return nil }
            return any as? [String:String]
        }
        
        // create albums in our context
        for entry in entries {
            // create object populate object using the manager
            
            guard let artistName = getValueOfAny(entry["im:artist"])?["label"] else { return [] }
            guard let albumName = getValueOfAny(entry["im:name"])?["label"] else { return [] }
            
            guard let releaseString = getValueOfAny(entry["im:releaseDate"])?["label"] else { return [] } // 2018-12-14T00:00:00-07:00
            guard let dateOfRelease = dateFormatter.date(from: releaseString) else { return []}
            
            guard let firstEntry = (entry["im:image"] as? [[String:Any]])?[0] as? [String:String] else { return [] }
            guard let imageURLString = firstEntry["label"] else { return [] }
            guard let imageLink = URL(string: imageURLString) else { return [] }
            
            guard let firstCategory = (entry["category"] as? [String:Any])?["attributes"] as? [String:String] else { return [] }
            guard let genre = firstCategory["term"] else { return [] }
            
            guard let priceString = getValueOfAny(entry["im:price"])?["label"] else { return [] } // "$12.21"
            guard let price = priceFormatter.number(from: priceString) else { return [] }
            
            let album = CoreDataManager.sharedInstance().createAlbum(with: artistName,
                                                                     albumName: albumName,
                                                                     release: dateOfRelease,
                                                                     imageURL: imageLink,
                                                                     genre: genre,
                                                                     price: price)
            // add object to albums
            dictAlbums.append(album)
        }
        
        return dictAlbums
        
    }
    
}
