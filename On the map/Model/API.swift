//
//  API.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 28/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import Foundation

class API {
    
    public static var sessionId: String?
    
    
    
    static func postSession(username: String, password: String, completion: @escaping (String?)->Void) {
        guard let url = URL(string: Constants.SESSION) else {
            completion("Supplied url is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    //Skipping the first 5 characters
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any],
                        let accountDict = dict["account"] as? [String: Any]  {
                        
                        CurrentClient.sharedInstance().currentStudent.uniqueKey = accountDict["key"] as? String
                        self.sessionId = sessionDict["id"] as? String
                        self.getUserInfo(completion: { err in
                            if err == nil {
                                errString = "Couldn't get the user info"
                            }
                        })
                    } else {
                        errString = "Couldn't parse response"
                    }
                } else { // Error in given login credintials
                    errString = "The email address or password is incorrect"
                }
            } else { // Request failed to sent
                errString = "Check your internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }
    
    
    static func deleteSession(completion: @escaping (String?)->Void) {
        guard let url = URL(string: Constants.SESSION) else {
            completion("Supplied url is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    
                    
                    let newData = data?.subdata(in: 5..<data!.count)
                    
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any] {
                        
                        
                        guard let session = sessionDict["id"] as? String else{
                            print("Can't find [session][id] in response")
                            return
                        }
                        self.sessionId = sessionDict["id"] as? String
                        
                        
                    } else {
                        errString = "Couldn't parse response"
                    }
                } else { // Error in given logout credintials
                    errString = "Provided logout credintials didn't match our records"
                }
            } else { // Request failed to sent
                errString = "Check your internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }
    
    
    
    
    static func getUserInfo(completion: @escaping (String?)->Void) {
    
        print(CurrentClient.sharedInstance().currentStudent.uniqueKey!)
        
        
        
        guard let url = URL(string: "\(Constants.STUDENT_LOCATION)?where=%7B%22uniqueKey%22%3A%22\(CurrentClient.sharedInstance().currentStudent.uniqueKey!)%22%7D") else {
            completion(nil)
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(Constants.HeaderValues.PARSE_APP_ID, forHTTPHeaderField: Constants.HeaderKeys.PARSE_APP_ID)
        request.addValue(Constants.HeaderValues.PARSE_API_KEY, forHTTPHeaderField: Constants.HeaderKeys.PARSE_API_KEY)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                        let dict = json as? [String:Any],
                        let results = dict["results"] as? [[String:Any]] {
                        

                        /*CurrentClient.sharedInstance().currentStudent.firstName = results[0]["firstName"] as? String ?? "first"
                        CurrentClient.sharedInstance().currentStudent.lastName = results[0]["lastName"] as? String ?? "last"*/
                        
                        
                        
                        for studentInfo in results {
                            let studentLocation1 = StudentInformation(dictionary: studentInfo as [String : AnyObject])
                            if studentLocation1.firstName != nil {
                                CurrentClient.sharedInstance().currentStudent.firstName = studentLocation1.firstName
                            }
                            
                            if studentLocation1.lastName != nil {
                                CurrentClient.sharedInstance().currentStudent.lastName = studentLocation1.lastName
                            }
                        }
                        
                    }
                } //Response is ok
            } //Request sent succesfully
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }
}
