//
//  Album+CoreDataProperties.swift
//  SignedInTunes
//
//  Created by Kevin Yu on 12/17/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var artist: String?
    @NSManaged public var albumName: String?
    @NSManaged public var albumImage: NSData?
    @NSManaged public var dateOfRelease: NSDate?
    @NSManaged public var imageLink: URL?
    @NSManaged public var genre: String?
    @NSManaged public var price: Double
    @NSManaged public var favorite: Bool
    @NSManaged public var user: User?

}
