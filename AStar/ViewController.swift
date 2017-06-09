//
//  ViewController.swift
//  AStar
//
//  Created by Lin Knudsen on 6/7/17.
//  Copyright © 2017 Lin Knudsen. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = skView {
            // Load the SKScene from 'GameScene.sks'
            let scene = PathScene(size: CGSize(width: view.frame.width, height: view.frame.height))
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            view.showsNodeCount = true
            view.showsFPS = true
        }
    }
}

