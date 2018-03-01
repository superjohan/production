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
    let sceneView = SCNView(frame: CGRect.zero)
    let camera = SCNNode()
    let groupLogo = UIImageView(image: UIImage(named: "dekadence"))
    let nameLogo = UIImageView(image: UIImage(named: "production"))
    let errorView = UIView()
    
    var boxes: [SCNNode] = []
    var isInErrorState = false
    var isInSilentState = false
    var isInSilent2State = false

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
        
        let camera = SCNCamera()
        camera.zFar = 600
        camera.vignettingIntensity = 1
        camera.vignettingPower = 1
        camera.colorFringeStrength = 3
        self.camera.camera = camera // lol
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .black
        self.sceneView.backgroundColor = .black
        self.sceneView.delegate = self
        
        self.view.addSubview(self.sceneView)
        self.view.addSubview(self.groupLogo)
        self.view.addSubview(self.nameLogo)
        self.view.addSubview(self.errorView)
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
        
        self.groupLogo.frame = self.sceneView.frame
        self.groupLogo.isHidden = true
        
        self.nameLogo.frame = self.sceneView.frame
        self.nameLogo.isHidden = true
        
        self.errorView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        start()
    }

    // MARK: - SCNSceneRendererDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            if (self.isInErrorState) {
                self.updateErrorState()
            }
        }
    }

    // MARK: - Private
    
    fileprivate func start() {
        scheduleEvents()
        
        self.audioPlayer.play()
    }
    
    fileprivate func scheduleEvents() {
        perform(#selector(showGroupLogo), with: NSNumber.init(booleanLiteral: true), afterDelay: 4)
        perform(#selector(showGroupLogo), with: NSNumber.init(booleanLiteral: false), afterDelay: 6)
        perform(#selector(setErrorState), with: NSNumber.init(booleanLiteral: true), afterDelay: 10)
        perform(#selector(setErrorState), with: NSNumber.init(booleanLiteral: false), afterDelay: 12)
        perform(#selector(showNameLogo), with: NSNumber.init(booleanLiteral: true), afterDelay: 16)
        perform(#selector(showNameLogo), with: NSNumber.init(booleanLiteral: false), afterDelay: 18)
        perform(#selector(setErrorState), with: NSNumber.init(booleanLiteral: true), afterDelay: 22)
        perform(#selector(setErrorState), with: NSNumber.init(booleanLiteral: false), afterDelay: 24)
        perform(#selector(setSilent1State), with: NSNumber.init(booleanLiteral: true), afterDelay: 28)
        perform(#selector(setSilent1State), with: NSNumber.init(booleanLiteral: false), afterDelay: 30)
        perform(#selector(setSilent2State), with: NSNumber.init(booleanLiteral: true), afterDelay: 32)
        perform(#selector(setSilent2State), with: NSNumber.init(booleanLiteral: false), afterDelay: 34)
        perform(#selector(endItAll), with: nil, afterDelay: 36)
    }
    
    @objc
    fileprivate func showGroupLogo(showBoolean: NSNumber) {
        let show = showBoolean.boolValue
        self.groupLogo.isHidden = !show
    }

    @objc
    fileprivate func showNameLogo(showBoolean: NSNumber) {
        let show = showBoolean.boolValue
        self.nameLogo.isHidden = !show
    }
    
    @objc
    fileprivate func setErrorState(errorStateBoolean: NSNumber) {
        let errorState = errorStateBoolean.boolValue
        self.isInErrorState = errorState
        
        if !errorState {
            self.sceneView.isHidden = false
            self.errorView.isHidden = true
        }
    }

    @objc
    fileprivate func setSilent1State(silentStateBoolean: NSNumber) {
        self.isInSilentState = silentStateBoolean.boolValue
    }

    @objc
    fileprivate func setSilent2State(silentStateBoolean: NSNumber) {
        self.isInSilent2State = silentStateBoolean.boolValue
    }

    @objc
    fileprivate func endItAll() {
        self.sceneView.isHidden = true
    }
    
    fileprivate func updateErrorState() {
        let isHidden = arc4random_uniform(2) == 1 ? false : true
        self.sceneView.isHidden = isHidden
        
        if !isHidden {
            let isErrorViewHidden = arc4random_uniform(2) == 1 ? false : true
            self.errorView.isHidden = isErrorViewHidden
            if !isErrorViewHidden {
                let horizontal = arc4random_uniform(2) == 1 ? false : true
                
                if horizontal {
                    self.errorView.frame = CGRect(
                        x: 0,
                        y: CGFloat(arc4random_uniform(UInt32(self.view.bounds.size.height))),
                        width: self.view.bounds.size.width,
                        height: CGFloat(arc4random_uniform(300))
                    )
                } else {
                    self.errorView.frame = CGRect(
                        x: CGFloat(arc4random_uniform(UInt32(self.view.bounds.size.width))),
                        y: 0,
                        width: CGFloat(arc4random_uniform(400)),
                        height: self.view.bounds.size.height
                    )
                }
                
                switch (arc4random_uniform(5)) {
                case 0:
                    self.errorView.backgroundColor = .green
                default:
                    self.errorView.backgroundColor = .black
                }
            }
        } else {
            self.errorView.isHidden = true
        }
    }
    
    fileprivate func createScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black

        self.camera.position = SCNVector3Make(0, 0, 58)

        scene.rootNode.addChildNode(self.camera)
        
        configureLight(scene)
        configureBoxes(scene)
        
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
    
    fileprivate func configureBoxes(_ scene: SCNScene) {
        let box = SCNBox(width: 200, height: 200, length: 200, chamferRadius: 0)
        let scale: Float = 150
        applyNoiseShader(object: box, scale: scale)
        box.firstMaterial?.isDoubleSided = true

        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3Make(0, 0, -90)

        scene.rootNode.addChildNode(boxNode)
        
        scene.rootNode.addChildNode(
            createBox(position: SCNVector3Make(-20, 20, 0), scale: scale + 20, size: 25)
        )
        scene.rootNode.addChildNode(
            createBox(position: SCNVector3Make(25, 0, 0), scale: scale - 20, size: 30)
        )
        scene.rootNode.addChildNode(
            createBox(position: SCNVector3Make(-10, -15, 0), scale: scale, size: 20)
        )
    }
    
    fileprivate func createBox(position: SCNVector3, scale: Float, size: CGFloat) -> SCNNode {
        let box = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        applyNoiseShader(object: box, scale: scale)
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = position
        
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
        
        return boxNode
    }
    
    fileprivate func applyNoiseShader(object: SCNGeometry, scale: Float) {
        do {
            object.firstMaterial?.shaderModifiers = [
                SCNShaderModifierEntryPoint.fragment: try String(contentsOfFile: Bundle.main.path(forResource: "noise.shader", ofType: "fragment")!, encoding: String.Encoding.utf8)
            ]
        } catch {}
        
        object.firstMaterial?.setValue(CGPoint(x: self.view.bounds.size.width, y: self.view.bounds.size.width), forKey: "resolution")
        object.firstMaterial?.setValue(scale, forKey: "scale")
    }
}
