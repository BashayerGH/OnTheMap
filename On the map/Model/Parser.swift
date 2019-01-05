//
//  Parse.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 28/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import Foundation

class Parser {
    
    static func getStudentLocations(limit: Int = 100, skip: Int = 0, orderBy: SLParam = .updatedAt, completion: @escaping (Locations?)->Void) {
        guard let url = URL(string: "\(Constants.STUDENT_LOCATION)?\(Constants.ParameterKeys.LIMIT)=\(limit)&\(Constants.ParameterKeys.SKIP)=\(skip)&\(Constants.ParameterKeys.ORDER)=-\(orderBy.rawValue)") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(Constants.HeaderValues.PARSE_APP_ID, forHTTPHeaderField: Constants.HeaderKeys.PARSE_APP_ID)
        request.addValue(Constants.HeaderValues.PARSE_API_KEY, forHTTPHeaderField: Constants.HeaderKeys.PARSE_API_KEY)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            var studentLocations: [StudentInformation] = []
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                        let dict = json as? [String:Any],
                        let results = dict["results"] as? [Any] {
                        
                        for location in results {
                            let data = try! JSONSerialization.data(withJSONObject: location)
                            let studentLocation1 = StudentInformation.init(dictionary: dict as [String : AnyObject])
                            
                            
                            studentLocations.append(studentLocation1)
                        }
                        
                    }
                }//Response is ok
            }
            
            DispatchQueue.main.async {
                completion(Locations(LocationsArray: studentLocations))
            }
            
        }
        task.resume()
    }
    
    static func postLocation(_ location: StudentInformation, completion: @escaping (String?)->Void) {
        /////////////\\\\\\\\\\\\\\///////////////////\\\\\\\\\\\\\\\\\\\\\\
        
        // Here you'll implement the logic for posting a student location
        // Please refere to the roadmap file and classroom for more details
        // Note that you'll need to send (uniqueKey, firstName, lastName) along with the post request. These information should be obtained upon logging in and they should be saved somewhere (Ex. AppDelegate or in this class)
    }
    
}
