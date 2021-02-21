//
//  ViewController.swift
//  NewPractice
//
//  Created by 諸星水晶 on 2020/12/10.
//

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene()
        
        let skView = self.view as! SKView
        
        scene.scaleMode = .aspectFill
        scene.size = skView.frame.size
        
        
        skView.presentScene(scene)
        
        
        skView.ignoresSiblingOrder = false
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.allButUpsideDown
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


