//
//  APIConstants.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 28/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import Foundation
struct Constants {
    
    struct HeaderKeys {
        static let PARSE_APP_ID = "X-Parse-Application-Id"
        static let PARSE_API_KEY = "X-Parse-REST-API-Key"
        
    }
    
    struct HeaderValues {
        static let PARSE_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let PARSE_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct ParameterKeys {
        static let LIMIT = "limit"
        static let SKIP = "skip"
        static let ORDER = "order"
    }
    
    // MARK: API Response Keys
    struct ResponseKeys {
        static let objectId = "object_id"
        static let uniqueKey = "unique_key"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let createdAt = "created_at"
        static let updatedAt = "updated_at"
        
    }

    
    private static let MAIN = "https://parse.udacity.com"
    static let SESSION = "https://onthemap-api.udacity.com/v1/session"
    static let PUBLIC_USER = "https://onthemap-api.udacity.com/v1/users/"
    static let STUDENT_LOCATION = MAIN + "/parse/classes/StudentLocation"
    
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
