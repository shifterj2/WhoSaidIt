//
//  GuessViewController.swift
//  MetroHacksTweets
//
//  Created by Aaron Kaufer on 5/21/17.
//  Copyright © 2017 Aaron Kaufer. All rights reserved.
//

import UIKit

let handles: [[String]] = [
["katyperry", "justinbieber", "taylorswift13", "rihanna", "ladygaga", "jtimberlake", "britneyspears", "selenagomez", "arianagrande", "shakira", "ddlovato", "jlo", "drake", "MileyCyrus", "OneDirection", "Harry_Styles", "LilTunechi", "BrunoMars", "NiallOfficial", "wizkhalifa", "Pink", "djkhaled", "Nickiminaj", "asahdkhaled"],
["TheEllenShow", "jtimberlake", "kimkardashian", "jimmyfallon", "shakira", "arianagrande", "ddlovato", "oprah", "kevinhart4real", "MileyCyrus", "SrBachchan", "danieltosh", "actuallynph", "iamsrk", "emmawatson", "KhloeKardashian", "conanobrien", "aplusk", "LeoDicaprio", "ryanseacrest"],
["BarackObama", "narendramodi", "realdonaldtrump", "POTUS", "chavezcandanga", "David_Cameron", "MedvedevRussiaE", "sachin_rt", "schwarzenegger", "mike_pence", "SenSanders", "sarahpalinusa"],
["YouTube", "twitter", "innocent", "instagram", "nytimes", "digiorno", "sportscenter", "jetblue", "ESPN", "nba", "nasa", "realmadrid", "NFL", "dennysdiner", "google", "Charmin", "oldspice", "tacobell", "Skittles", "toyota"],
["Cristiano", "kingjames", "neymarjr", "Kaka", "kdtrey5", "realmadrid", "nba", "espn", "sportscenter", "NFL", "CP3", "ochocinco", "lancearmstrong", "patriots", "sachin_rt", "michaelphelps", "amer_pharoah", "Lavarbigballer", "TomBradysEgo", "JManziel2"]
]

let names: [[String]] = [
["Katy Perry", "Justin Bieber", "Taylor Swift", "Rihanna", "Lady Gaga", "Justin Timberlake", "Britney Spears", "Selena Gomez", "Ariana Grande", "Shakira", "Demi Lovato", "Jennifer Lopez", "Drake", "Miley Ray Cyrus", "One Direction", "Harry Styles", "Lil Wayne", "Bruno Mars", "Niall Horan", "Wiz Khalifa", "P!nk", "DJ Khaled", "Nicki Minaj", "Asahd Khaled"],
["Ellen DeGeneres", "Justin Timberlake", "Kim Kardashian West", "Jimmy Fallon", "Shakira", "Ariana Grande", "Demi Lovato", "Oprah Winfrey", "Kevin Hart", "Miley Ray Cyrus", "Amitabh Bachchan", "Daniel Tosh", "Neil Patrick Harris", "Shah Rukh Khan", "Emma Watson", "Khloe Kardashian", "Conan O’Brien", "Ashton Kutcher", "Leonardo DiCaprio", "Ryan Seacrest"],
["Barack Obama", "Narendra Modi", "Donald J. Trump (personal)", "President Trump", "Hugo Chavez", "David Cameron", "Dmitry Medvedev", "Sachin Tendulkar", "Arnold Schwarzenegger", "Mike Pence", "Bernie Sanders", "Sarah Palin"],
["YouTube", "Twitter", "Innocent Drinks", "Instagram", "The New York Times", "DiGiorno Pizza", "SportsCenter", "JetBlue Airways", "ESPN", "NBA", "NASA", "Real Madrid C.F.", "NFL", "Denny’s", "Google", "Charmin", "Old Spice", "Taco Bell", "Skittles", "Toyota"],
["Cristiano Ronaldo", "LeBron James", "Neymar Jr.", "Kaka", "Kevin Durant", "Real Madrid C.F.", "NBA", "ESPN", "SportsCenter", "NFL", "Chris Paul", "Chad (Ochocinco) Johnson", "Lance Armstrong", "New England Patriots", "Sachin Tendulkar", "Michael Phelps", "American Pharoah", "Lavar Ball", "Tom Brady’s Ego", "Johnny Manziel"]
]

class GuessViewController: UIViewController {

    
    @IBOutlet weak var endScreen: UIView!
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var pointsLeft: UILabel!
    @IBOutlet weak var scoreText: UILabel!
    var categoryNum: Int = 0
    var user = 0
    var correct = 0
    var correct_counter: Int = 0
    var wrong_already = false
    var question_counter: Int = 0
    var score = 0
    var pressedWrong = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        correct_counter = 0
        question_counter = 0
        
        loadTweet()
        
        option1.titleLabel?.adjustsFontSizeToFitWidth = true
        option2.titleLabel?.adjustsFontSizeToFitWidth = true
        option3.titleLabel?.adjustsFontSizeToFitWidth = true
        option4.titleLabel?.adjustsFontSizeToFitWidth = true
        
        option1.titleLabel?.minimumScaleFactor = 0.2
        option2.titleLabel?.minimumScaleFactor = 0.2
        option3.titleLabel?.minimumScaleFactor = 0.2
        option4.titleLabel?.minimumScaleFactor = 0.2
        
        // Do any additional setup after loading the view.
    }
    
    var timer = Timer()
    var time = 0.0
    
    let kTime = 13.0
    
    func startTimer(){
        time = 0.0
        timerView.frame = CGRect(x: 45, y: 24, width: 285, height: 30)
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true){_ in
            self.time += 0.03
            self.timerView.frame = CGRect(x: 45 + (self.time)*285/self.kTime, y: 24, width: 285*(self.kTime-self.time)/self.kTime, height: 30)
            self.timerView.backgroundColor = UIColor(colorLiteralRed: Float((self.time)/self.kTime), green: Float((self.kTime-self.time)/self.kTime), blue: 0, alpha: 1)
            if(self.time >= self.kTime){
                self.outOfTime()
            }
        }
    }
    func pauseTimer(){
        timer.invalidate()
    }
    
    func outOfTime(){
        timer.invalidate()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false){_ in
            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "EndScreen") as! EndViewController
            nvc.category = self.categoryNum
            self.present(nvc, animated: true){_ in
                nvc.scoreText.text = "\(self.score)"
            }
        }
    }
    
    func loadTweet(){
        
        pauseTimer()
        
        option1.isEnabled = true
        option2.isEnabled = true
        option3.isEnabled = true
        option4.isEnabled = true
        
        
        self.pressedWrong = 0
        self.question_counter += 1
        self.wrong_already = false
        self.pointsLeft.text = "30"
        
        let numUsers = handles[categoryNum].count
        
        option1.backgroundColor = UIColor.white
        option2.backgroundColor = UIColor.white
        option3.backgroundColor = UIColor.white
        option4.backgroundColor = UIColor.white
        
        
        user = Int(arc4random_uniform(UInt32(numUsers)))
        
        TweetLoader.tweetsFromUser(user: handles[categoryNum][user]){tweets in
            
            self.startTimer()
            
            self.option1.isEnabled = true
            self.option2.isEnabled = true
            self.option3.isEnabled = true
            self.option4.isEnabled = true
            
            //for t in tweets{
            //    print(t)
            //    print()
            //}
            let generator = MarkovGenerator()
            let tweet = generator.generateTweet(from: tweets)
            self.tweetText.text = tweet
            
            var r1 = 0
            var r2 = 0
            var r3 = 0
            var r4 = 0
            
            while(r1 == r2 || r1 == r3 || r1 == r4 || r2 == r3 || r2 == r4 || r3 == r4){
                
                r1 = Int(arc4random_uniform(UInt32(numUsers)))
                r2 = Int(arc4random_uniform(UInt32(numUsers)))
                r3 = Int(arc4random_uniform(UInt32(numUsers)))
                r4 = Int(arc4random_uniform(UInt32(numUsers)))
                
                if( r1 == self.user || r2 == self.user || r3 == self.user || r4 == self.user){
                    r1 = r2
                    continue
                }
            }
            
            
            self.option1.setTitle(names[self.categoryNum][r1], for: UIControlState.normal)
            self.option2.setTitle(names[self.categoryNum][r2], for: UIControlState.normal)
            self.option3.setTitle(names[self.categoryNum][r3], for: UIControlState.normal)
            self.option4.setTitle(names[self.categoryNum][r4], for: UIControlState.normal)
            
            
            let r = arc4random_uniform(4)
            
            //if(r == 0){self.option1.titleLabel?.text = handles[self.categoryNum][self.user]}
            //if(r == 1){self.option2.titleLabel?.text = handles[self.categoryNum][self.user]}
            //if(r == 2){self.option3.titleLabel?.text = handles[self.categoryNum][self.user]}
            //if(r == 3){self.option4.titleLabel?.text = handles[self.categoryNum][self.user]}
            
            if(r == 0){self.option1.setTitle(names[self.categoryNum][self.user], for: UIControlState.normal)}
            if(r == 1){self.option2.setTitle(names[self.categoryNum][self.user], for: UIControlState.normal)}
            if(r == 2){self.option3.setTitle(names[self.categoryNum][self.user], for: UIControlState.normal)}
            if(r == 3){self.option4.setTitle(names[self.categoryNum][self.user], for: UIControlState.normal)}

            
            self.correct = Int(r)+1
            print("correct:" + handles[self.categoryNum][self.user] + " \(self.correct)")
            //}
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!

    @IBOutlet weak var option4: UIButton!

    @IBOutlet weak var tweetText: UILabel!
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        let bootyhole = sender as! UIButton
        let num = bootyhole.tag - 100
        
        bootyhole.isEnabled = false
        
        if(num == correct){
            pauseTimer()
            
            self.score += 30 - self.pressedWrong*10
            scoreText.text = "\(self.score)"
            if(!self.wrong_already){
                self.correct_counter+=1
            }
            bootyhole.backgroundColor = UIColor.green
            
            
            if(self.question_counter == 5){
            
                //endScreen.isHidden = false
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false){_ in
                    let nvc = self.storyboard?.instantiateViewController(withIdentifier: "EndScreen") as! EndViewController
                    nvc.category = self.categoryNum
                    self.present(nvc, animated: true){_ in
                        nvc.scoreText.text = "\(self.score)"
                    }
                }
            
            }else{
                option1.isEnabled = false
                option2.isEnabled = false
                option3.isEnabled = false
                option4.isEnabled = false
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false){_ in
                    self.loadTweet()
                }
            }
        }
        else{
            pressedWrong += 1
            self.pointsLeft.text = "\(30-self.pressedWrong*10)"
            self.wrong_already = true
            bootyhole.backgroundColor = UIColor.red
        }
        
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bigbootyhole = segue.destination as! EndViewController
        
        bigbootyhole.scoreText.text = "\(self.score)"
    }*/
 

}
