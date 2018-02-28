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

class ViewController: UIViewController, SCNSceneRendererDelegate {
    let audioPlayer: AVAudioPlayer
    let sceneView: SCNView
    let camera: SCNNode

    // MARK: - UIViewController
    
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
        
        self.view.backgroundColor = .black
        self.sceneView.backgroundColor = .black
        self.sceneView.delegate = self
        
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

        self.sceneView.scene = createScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.sceneView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.sceneView.isPlaying = true
    }
    
    // MARK: - SCNSceneRendererDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }

    // MARK: - Private
    
    fileprivate func createScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black

        self.camera.position = SCNVector3Make(0, 0, 58)

        scene.rootNode.addChildNode(self.camera)
        
        configureLight(scene)
        configureBox(scene)
        
        return scene
    }

    fileprivate func configureLight(_ scene: SCNScene) {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = UIColor(white: 1.0, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 0, 60)
        scene.rootNode.addChildNode(omniLightNode)
    }
    
    var box: SCNBox?
    
    fileprivate func configureBox(_ scene: SCNScene) {
        let box = SCNBox(width: 25, height: 25, length: 25, chamferRadius: 0)
        applyNoiseShader(box)
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3Make(0, 0, 0)
    
        boxNode.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(
                    x: CGFloat(-10 + Int(arc4random_uniform(20))),
                    y: CGFloat(-10 + Int(arc4random_uniform(20))),
                    z: CGFloat(-10 + Int(arc4random_uniform(20))),
                    duration: TimeInterval(8 + arc4random_uniform(5))
                )
            )
        )

        self.box = box
        
        scene.rootNode.addChildNode(boxNode)
    }
    
    fileprivate func applyNoiseShader(_ object: SCNGeometry) {
        do {
            object.firstMaterial?.shaderModifiers = [
                SCNShaderModifierEntryPoint.fragment: try String(contentsOfFile: Bundle.main.path(forResource: "noise.shader", ofType: "fragment")!, encoding: String.Encoding.utf8)
            ]
        } catch {}
        
        object.firstMaterial?.setValue(CGPoint(x: self.view.bounds.size.width, y: self.view.bounds.size.width), forKey: "resolution")
    }
}
