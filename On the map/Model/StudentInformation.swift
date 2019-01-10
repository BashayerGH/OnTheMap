//
//  File.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 28/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    // MARK: Properties

    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var createdAt: String?
    var updatedAt: String?
    
    
    
    // MARK: Initializers
    
    // construct a StudentInformation from a dictionary
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        objectId = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniqueKey"] as? String
        createdAt = dictionary["createdAt"] as? String
        updatedAt = dictionary["updatedAt"] as? String
    }
    
    init(first: String, last: String, url: String, date: String) {
        firstName = first
        lastName = last
        mediaURL = url
        updatedAt = date
    }
    
    init(mapString1: String, mediaURL1: String)
    {
        mapString = mapString1
        mediaURL = mediaURL1
    }
    
    init() {
        firstName = ""
        lastName = ""
        latitude = 0.0
        longitude = 0.0
        mapString = ""
        mediaURL = ""
        objectId = ""
        uniqueKey = ""
        createdAt = ""
        updatedAt = ""
    }
}

enum SLParam: String {
    case createdAt
    case firstName
    case lastName
    case latitude
    case longitude
    case mapString
    case mediaURL
    case objectId
    case uniqueKey
    case updatedAt
}
