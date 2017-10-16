//
//  ViewController.swift
//  MetroHacksTweets
//
//  Created by Aaron Kaufer on 5/20/17.
//  Copyright © 2017 Aaron Kaufer. All rights reserved.
//

import UIKit

extension String{
    func cleanHTTP() -> String{
        
        
        let strArr = self.components(separatedBy: " ")
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
        
        
        return str.substring(from: 1)
    }
}

class ViewController: UIViewController {

     var handles = ["katyperry", "justinbieber", "taylorswift13", "rihanna", "ladygaga", "jtimberlake", "britneyspears", "selenagomez", "arianagrande", "shakira", "ddlovato", "jlo", "drake", "MileyCyrus", "OneDirection", "Harry_Styles", "LilTunechi", "BrunoMars", "NiallOfficial", "wizkhalifa", "Pink", "djkhaled", "Nickiminaj", "asahdkhaled", "TheEllenShow", "jtimberlake", "kimkardashian", "jimmyfallon", "shakira", "arianagrande", "ddlovato", "oprah", "kevinhart4real", "MileyCyrus", "SrBachchan", "danieltosh", "Neil Patrick Harris", "iamsrk", "emmawatson", "KhloeKardashian", "conanobrien", "aplusk", "LeoDicaprio", "ryanseacrest","BarackObama", "narendramodi", "realdonaldtrump", "POTUS", "chavezcandaga", "David_Cameron", "MedvedevRussiaE", "sachin_rt", "schwarzenegger", "mike_pence", "SenSanders", "sarahpalinusa","YouTube", "twitter", "cnnbrk", "instagram", "nytimes", "CNN", "sportscenter", "BBCBreaking", "ESPN", "nba", "nasa", "realmadrid", "NFL", "dennysdiner", "google", "Charmin", "oldspice", "tacobell", "Skittles", "toyota","Cristiano", "kingjames", "neymarjr", "Kaka", "kdtrey5", "realmadrid", "nba", "espn", "sportscenter", "NFL", "CP3", "ochocinco", "lancearmstrong", "patriots", "sachin_rt", "michaelphelps", "amer_pharoah", "Lavarbigballer", "TomBradysEgo", "JManziel2"]
    
    var tweetTimer: Timer!
    @IBOutlet weak var quoteText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update_tweet()
        tweetTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(update_tweet), userInfo: nil, repeats: true)
        
        
        TweetLoader.tweetsFromUser(user: "sarahpalinusa"){tweets in
            let generator = MarkovGenerator()
            print(generator.generateTweet(from: tweets))
        }
        
        //let m = Markov()
        //m.processString(str: "A B C B C A A C B B")
        //m.printSelf()
    }

    func update_tweet(){
        
        let randomIndex = Int(arc4random_uniform(UInt32(self.handles.count)))
        TweetLoader.rawTweetsFromUser(user: self.handles[randomIndex]){tweets in
            
            let randomIndexTWO = Int(arc4random_uniform(UInt32(tweets.count)))
            
            if(tweets.count > 0){
                self.quoteText.text = "\"" + tweets[randomIndexTWO].cleanHTTP() + "\"" + " —" + self.handles[randomIndex]
                
            }else{
                
                self.update_tweet()
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dest = segue.destination as! GuessViewController
        dest.categoryNum = (sender as! UIButton).tag - 101
        
        print(dest.categoryNum)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}

