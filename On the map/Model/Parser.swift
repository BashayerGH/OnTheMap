//
//  Parse.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 28/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import Foundation

class Parser {
    
    static func getStudentLocations(limit: Int = 100, orderBy: SLParam = .updatedAt, completion: @escaping (Locations?)->Void) {
        guard let url = URL(string: "\(Constants.STUDENT_LOCATION)?\(Constants.ParameterKeys.LIMIT)=\(limit)&\(Constants.ParameterKeys.ORDER)=-\(orderBy.rawValue)") else {
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
                        let results = dict["results"] as? [[String:AnyObject]] {
                        
                        for location in results {
                            let studentLocation1 = StudentInformation(dictionary: location)
                            
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
    
    static func postLocation(location: StudentInformation, completion: @escaping (String?)->Void) {
        
        guard let url = URL(string: Constants.STUDENT_LOCATION) else {
            completion("Error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue(Constants.HeaderValues.PARSE_APP_ID, forHTTPHeaderField: Constants.HeaderKeys.PARSE_APP_ID)
        request.addValue(Constants.HeaderValues.PARSE_API_KEY, forHTTPHeaderField: Constants.HeaderKeys.PARSE_API_KEY)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("lat \(location.latitude!)")
        print("lon \(location.longitude!)")
        
        
        
        request.httpBody = "{\"uniqueKey\": \"\(CurrentClient.sharedInstance().currentStudent.uniqueKey!)\", \"firstName\": \"\(CurrentClient.sharedInstance().currentStudent.firstName!)\", \"lastName\": \"\(CurrentClient.sharedInstance().currentStudent.lastName!)\",\"mapString\": \"\(location.mapString!)\", \"mediaURL\": \"\(location.mediaURL!)\",\"latitude\": \(location.latitude!), \"longitude\": \(location.longitude!)}".data(using: .utf8)

        
        
        let session = URLSession.shared
        

        let task = session.dataTask(with: request) { (results, response, error) in
            

            if error != nil {
                completion("The post fails! try again later")
                return
            }
            print(String(data: results!, encoding: .utf8)!)
            
            DispatchQueue.main.async {
                completion(nil)
            }

        }
        task.resume()
    }
    
}
