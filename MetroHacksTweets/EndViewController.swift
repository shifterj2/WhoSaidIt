//
//  EndViewController.swift
//  MetroHacksTweets
//
//  Created by Aaron Kaufer on 5/21/17.
//  Copyright © 2017 Aaron Kaufer. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    @IBOutlet weak var scoreText: UILabel!
    
    var category = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print("catgory: \(category)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if((sender as! UIButton).tag == 101){
            let sharpieInsidePenisHole = segue.destination as! GuessViewController
            sharpieInsidePenisHole.categoryNum = category
        }
        
        
    }
 

}
