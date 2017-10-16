//
//  TweetLoader.swift
//  MetroHacksTweets
//
//  Created by Aaron Kaufer on 5/20/17.
//  Copyright © 2017 Aaron Kaufer. All rights reserved.
//

import UIKit
import TwitterKit

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

let punctuation = ["\"", ",", ";","!","(",")","”"]
extension String{
    func clean() -> String{
        var lc = self.lowercased()
        lc = lc.replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)
        lc = lc.replacingOccurrences(of: "➡️", with: " ", options: .literal, range: nil)
        
        let strArr = lc.components(separatedBy: " ")
        var str = ""
        for s in strArr{
            if (s.characters.count >= 4 && s.substring(to: 4) == "http"){
                continue
            }
            str = str + " \(s)"
        }
        if(str.characters.count <= 1){
            return ""
        }
        str = str.substring(from: 1)
        for punc in punctuation{
            str = str.replacingOccurrences(of: punc, with: " ", options: .literal, range: nil)
        }
        str = str.replacingOccurrences(of: "?", with: " ?", options: .literal, range: nil)
        str = str.condenseWhitespace()
        str = str.replacingOccurrences(of: "&amp", with: "&", options: .literal, range: nil)
        return str
    }
}

class TweetLoader: NSObject {

    
    
    class func tweetsFromUser(user: String, finished: @escaping (_ tweets: [String]) -> ()){
    
        let client = TWTRAPIClient()
        
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["screen_name": user, "count": "10000", "include_rts":"false", "tweet_mode":"extended"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            
            do {
                if(data == nil){
                    print(user)
                    return
                }
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                //print("json: \(json)")
                
                let jsonArr = json as! NSArray
                var tweets: [String] = []
                
                for tweet in jsonArr{
                    
                    let t = tweet as! NSDictionary
                    //print(t)
                    if (t["full_text"] != nil){
                        let text = t["full_text"] as! String
                        tweets.append(text.clean())
                    }
                    
                }
                finished(tweets)
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
    }
    
    
    class func rawTweetsFromUser(user: String, finished: @escaping (_ tweets: [String]) -> ()){
        
        let client = TWTRAPIClient()
        
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["screen_name": user, "count": "10000", "include_rts":"false", "tweet_mode":"extended"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            
            do {
                if(data == nil){
                    print(user)
                    return
                }
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                //print("json: \(json)")
                
                let jsonArr = json as! NSArray
                var tweets: [String] = []
                
                for tweet in jsonArr{
                    
                    let t = tweet as! NSDictionary
                    //print(t)
                    if (t["full_text"] != nil){
                        let text = t["full_text"] as! String
                        tweets.append(text)
                    }
                    
                }
                finished(tweets)
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
    }

    
}
