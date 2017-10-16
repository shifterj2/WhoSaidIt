//
//  Markov.swift
//  MetroHacksTweets
//
//  Created by Aaron Kaufer on 5/21/17.
//  Copyright © 2017 Aaron Kaufer. All rights reserved.
//

import UIKit

class Markov: NSObject {

    var states: [String] = []
    var stateIndex: [String: Int] = [:]
    var stateCount: Int = 0
    var nextStates: [[String]] = []
    var startStates:[String] = []
    var totalFreq: [String: Int] = [:]
    var endFreq: [String: Int] = [:]
    
    func processString(str: String){
        var words = str.components(separatedBy: " ")
        //first do single states
        if(words.count == 0){ return }
        for i in 0...(words.count - 1) {
            let word = words[i]
            if (i == 0){startStates.append(word)}
            
            if(stateIndex[word] == nil){
                states.append(word)
                stateIndex[word] = stateCount
                nextStates.append([String]())
                stateCount += 1
                totalFreq[word] = 0
                endFreq[word] = 0
            }
            
            let index = stateIndex[word]!
            totalFreq[word]! += 1
            
            if(i < words.count-1){
                nextStates[index].append(words[i+1])
            }
            if(i < words.count-2){
                nextStates[index].append("\(words[i+1]) \(words[i+2])")
            }
            if(i == words.count-1){
                endFreq[word]! += 1
            }
        }
        
        //next do double states
        if(words.count <= 1){ return }
        for i in 0...(words.count - 2){
            let state = "\(words[i]) \(words[i+1])"
            if (i == 0){startStates.append(state)}
            
            if(stateIndex[state] == nil){
                states.append(state)
                stateIndex[state] = stateCount
                nextStates.append([String]())
                stateCount += 1
                totalFreq[state] = 0
                endFreq[state] = 0
            }
            
            let index = stateIndex[state]!
            totalFreq[state]! += 1
            
            if(i < words.count - 2){
                nextStates[index].append(words[i+2])
            }
            if(i < words.count-3){
                nextStates[index].append("\(words[i+2]) \(words[i+3])")
            }
            if(i == words.count-2){
                endFreq[state]! += 1
            }
        }
    }
    
    func simulate() -> String{
        
        var str = ""
        
        var currentState = ""
        let r = Int(arc4random_uniform(UInt32(startStates.count)))
        currentState = startStates[r]
        
        while true {
            str = str + " " + currentState
            
            //check if end state
            let r2 = Int(arc4random_uniform(UInt32( totalFreq[currentState]! )))
            if (r2 < endFreq[currentState]!){
                break
            }
            
            var nextState = ""
            let index = stateIndex[currentState]!
            let r = Int(arc4random_uniform(UInt32(nextStates[index].count)))
            nextState = nextStates[index][r]
            
            currentState = nextState
            
        }
        
        return str.substring(from: 1)
    }
    
    func generateMarkov(badStrings: [String]) -> String{
        var counter = 0
        while true {
            counter += 1
            
            let s = simulate()
            print("Attempt: \(s)")
            print()
            
            if(counter == 50){
                return s
            }
            
            if(s.characters.count < 40 || s.characters.count > 140){
                continue
            }
            if(badStrings.contains(s)){
                continue
            }
            
            return s
        }
    }
    
    func printSelf(){
        for state in states{
            print("State: \(state)")
            print("Next: \(nextStates[stateIndex[state]!])")
        }
    }
    
}
