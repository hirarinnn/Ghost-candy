//
//  RankingViewController.swift
//  NewPractice
//
//  Created by 平川麟太郎 on 2021/01/24.
//

import UIKit

class RankingViewController: UIViewController {

    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    
    let Savedata = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.text = String(Savedata.integer(forKey: "score1"))
        label2.text = String(Savedata.integer(forKey: "score2"))
        label3.text = String(Savedata.integer(forKey: "score3"))
      
    }
    @IBAction func gotoTOP() {
        self.dismiss(animated: true, completion: nil)
    }

  
}
