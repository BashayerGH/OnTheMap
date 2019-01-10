//
//  UserInfo.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 28/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import Foundation

struct UserInfo {
    public static var key: String?
    public static var firstName: String?
    public static var lastName: String?
    
    init() {
        //temporary, because I can't get student information
        UserInfo.key = ""
        UserInfo.firstName = "test1"
        UserInfo.lastName = "test2"
    }
}
