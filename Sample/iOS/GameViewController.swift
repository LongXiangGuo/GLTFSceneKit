//
//  GameViewController.swift
//  GLTFSceneKitSampler
//
//  Created by magicien on 2017/08/26.
//  Copyright © 2017年 DarkHorse. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import GLTFSceneKit

class GameViewController: UIViewController {
    
    var gameView: SCNView? {
        get { return self.view as? SCNView }
    }
    var scene: SCNScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var scene: SCNScene
        do {
         //   let sceneSource = try GLTFSceneSource(named: "art.scnassets/Test/iX_Nan.glb")
            let sceneSource = GLTFSceneSource(url: Bundle.main.url(forResource: "iX_Nan", withExtension: "glb")!)
            scene = try sceneSource.scene()
            scene.rootNode.scale = SCNVector3(1, 1, 1)
        } catch {
            print("\(error.localizedDescription)")
            return
        }
        let light = SCNLight()
        light.color = UIColor.white
        light.name = "custom_light"
        light.intensity = 1
        light.type = .ambient
        scene.rootNode.light = light
        
        self.setScene(scene)
        self.gameView!.autoenablesDefaultLighting = true
        
        // allows the user to manipulate the camera
        self.gameView!.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        self.gameView!.showsStatistics = true
        
        // configure the view
        self.gameView!.backgroundColor = UIColor.white

        self.gameView!.delegate = self
    }
    
    func setScene(_ scene: SCNScene) {
        // set the scene to the view
        self.gameView!.scene = scene
        self.scene = scene

        //to give nice reflections :)
//        scene.lightingEnvironment.contents = "art.scnassets/shinyRoom.jpg"
        scene.lightingEnvironment.intensity = 2;
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

extension GameViewController: SCNSceneRendererDelegate {
  func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
    self.scene?.rootNode.updateVRMSpringBones(time: time)
  }
}
