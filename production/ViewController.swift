//
//  ViewController.swift
//  production
//
//  Created by Johan Halin on 28/02/2018.
//  Copyright © 2018 Jumalauta. All rights reserved.
//

import UIKit
import AVFoundation
import SceneKit

class ViewController: UIViewController {
    let audioPlayer: AVAudioPlayer
    let sceneView: SCNView
    let camera: SCNNode

    init() {
        if let trackUrl = Bundle.main.url(forResource: "audio", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        self.sceneView = SCNView(frame: CGRect.zero)
        
        self.camera = SCNNode()
        let camera = SCNCamera()
        camera.zFar = 600
        camera.vignettingIntensity = 1
        camera.vignettingPower = 1
        self.camera.camera = camera // lol
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.addSubview(self.sceneView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.audioPlayer.prepareToPlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.sceneView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
}

