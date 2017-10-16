//
//  MarkovGenerator.swift
//  MetroHacksTweets
//
//  Created by Aaron Kaufer on 5/20/17.
//  Copyright © 2017 Aaron Kaufer. All rights reserved.
//

import UIKit

class MarkovGenerator: NSObject {
    
    func generateTweet(from: [String]) -> String{
        let m = Markov()
        for s in from {
            m.processString(str: s)
        }
        return m.generateMarkov(badStrings: from)
    }
    
    func attemptTweet(startWords: [String], Master_Dict: [String: [String: Int]], endCount: [String: Int], totalCount: [String: Int]) -> String{
        var final_tweet = ""
        var index: Int = Int(arc4random_uniform(UInt32(startWords.count)))
        var start_word = startWords[index]
        
        /*while start_word == nil {
         index = Int(arc4random_uniform(UInt32(Master_Dict.count)))
         start_word = Array(Master_Dict.keys)[index]
         }*/
        
        final_tweet += start_word + " "
        
        while true{
            
            if(Master_Dict[start_word] == nil) { return "hi" }
            var word = select_word(dict: Master_Dict[start_word]!)
            
            var counter = 0
            
            while Master_Dict[word] == nil {
                
                word = select_word(dict: Master_Dict[start_word]!)
                counter += 1
                
                if counter == 10 {
                    
                    index = Int(arc4random_uniform(UInt32(Master_Dict.count)))
                    word = Array(Master_Dict.keys)[index]
                    
                }
                
            }
            final_tweet += word + " "
            start_word = word
            
            let tot = totalCount[word]!
            let end = endCount[word]!
            let r = arc4random_uniform(UInt32(tot))
            if(Int(r) < end){
                break
            }
            
            
        }
        return final_tweet
    }
    
    func makeDicitonary(input_arr: [String]) -> String{
        
        var startWords = [String]()
        var Master_Dict = [String: [String: Int]]()
        var endCount = [String: Int]()
        var totalCount = [String: Int]()
        
        
        for tweet in input_arr{
            var words = tweet.components(separatedBy: " ")
            startWords.append(words[0])
            if(words.count <= 2){
                continue
            }
            for i in 0...words.count-1{
                if(totalCount[words[i]] == nil) { totalCount[words[i]] = 0 }
                if(endCount[words[i]] == nil){ endCount[words[i]] = 0 }
                    
                else{ totalCount[words[i]]! += 1 }
                if(i == words.count-1){
                    endCount[words[i]]! += 1
                }
            }
            for i in 0...words.count-2{
                if Master_Dict[words[i]] == nil{
                    Master_Dict[words[i]] = [String: Int]()
                }
                if Master_Dict[words[i]]![words[i+1]] == nil{
                    Master_Dict[words[i]]![words[i+1]] = 1
                }else{
                    Master_Dict[words[i]]![words[i+1]] = Master_Dict[words[i]]![words[i+1]]!+1
                }
            }
        }
        
        
        var tweet: String = ""
        while(true){
            tweet = attemptTweet(startWords: startWords, Master_Dict: Master_Dict, endCount: endCount, totalCount: totalCount)
            //print("Attempt: \(tweet) \n")
            if(tweet.characters.count <= 140 && tweet.characters.count >= 40){
                break
            }
        }
        return tweet;
        
        
        
    }
    
    func select_word(dict:[String:Int]) -> String{
        
        var random_list = [String]()
        
        for (word,freq) in dict{
            
            for _ in 1...freq{
                random_list.append(word)
            }
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(random_list.count)))
        return random_list[randomIndex]
        
    }
    
}
