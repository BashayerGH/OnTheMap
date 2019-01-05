//
//  CurrentClient.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 29/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import Foundation
class CurrentClient {
    
    var currentStudent = StudentInformation()
    
    // singleton
    class func sharedInstance() -> CurrentClient {
        struct Singleton {
            static var sharedInstance = CurrentClient()
        }
        return Singleton.sharedInstance;
    }
}
