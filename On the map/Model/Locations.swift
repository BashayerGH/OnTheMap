//
//  Locations.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 28/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import Foundation

struct Locations {
    var LocationsArray: [StudentInformation] = []
    
    // singleton
    static func sharedInstance() -> Locations {
        struct Singleton {
            static var sharedInstance = Locations()
        }
        return Singleton.sharedInstance
    }
    
}
