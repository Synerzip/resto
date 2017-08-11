//
//  MenuPreviewViewController.swift
//  Resto
//
//  Created by Aditya Kulkarni on 19/07/17.
//  Copyright © 2017 Synerzip. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class MenuPreviewViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var session = ARSession()
    var config: ARConfiguration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupScene()
        enableEnvironmentMapWithIntensity(30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        restartPlaneDetection()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        session.pause()
        dismiss(animated: true, completion: nil)
    }
    
    func setupScene() {
        // set up sceneView
        sceneView.delegate = self
        sceneView.session = session
        sceneView.antialiasingMode = .multisampling4X
        sceneView.automaticallyUpdatesLighting = false
        sceneView.autoenablesDefaultLighting = true
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 1.3
        sceneView.showsStatistics = true
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset = -1
            camera.minimumExposure = -1
        }
    }
    
    func restartPlaneDetection() {
        
        // configure session
        if let worldSessionConfig = config as? ARWorldTrackingConfiguration {
            worldSessionConfig.planeDetection = .horizontal
            session.run(worldSessionConfig, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if sceneView.scene.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
                sceneView.scene.lightingEnvironment.contents = environmentMap
            }
        }
        sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    func addItemWith(name: String) -> SCNNode {
        let wrapper = SCNNode()
        
        //add image of an ingredient
        let plane = SCNPlane(width: 0.05, height: 0.05)
        plane.firstMaterial?.diffuse.contents = UIImage(named: name)
        let planeNode = SCNNode(geometry: plane)
        planeNode.constraints = [SCNBillboardConstraint()]
        plane.firstMaterial?.isDoubleSided = true
        wrapper.addChildNode(planeNode)
        
        //add name of an ingredient
        let text = SCNText(string: name, extrusionDepth: 0.5)
        text.firstMaterial?.diffuse.contents = UIColor.yellow
        text.firstMaterial?.isDoubleSided = true
        let nameNode = SCNNode(geometry: text)
        nameNode.scale = SCNVector3(0.001,0.001,0.001)
        nameNode.position = SCNVector3Zero
        wrapper.addChildNode(nameNode)
        let itemBoundingBox = planeNode.boundingBox
        let nameBoundingBox = nameNode.boundingBox
        let xPos = (planeNode.position.x - (nameBoundingBox.max.x - nameBoundingBox.min.x)/2.0) / 1000
        let yPos = itemBoundingBox.min.y - (nameBoundingBox.max.y - nameBoundingBox.min.y)/1000 - 0.005
        nameNode.position = SCNVector3(xPos, yPos, planeNode.position.z)

        return wrapper
    }
    
    func loadModel(anchor: ARPlaneAnchor) -> SCNNode? {
        guard let virtualObjectScene = SCNScene(named: "cup.scn", inDirectory: "Models.scnassets/cup") else {
            return nil
        }
        let wrapperNode = SCNNode()
        wrapperNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        //create and add food Item
        let foodItemNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            foodItemNode.addChildNode(child)
        }
        wrapperNode.addChildNode(foodItemNode)
        
        //create and add ingredients around food item
        let ingredients = ["PotatoMashed", "Milk", "Sugar", "TeaPowder", "Water"]
        for item in ingredients {
            let foodNameNode = addItemWith(name: item)
            let foodBoundingBox = foodItemNode.boundingBox
            let totalXDist = foodBoundingBox.max.x - foodBoundingBox.min.x
            let totalYDist = foodBoundingBox.max.y - foodBoundingBox.min.y
            let displacement = totalXDist / Float(ingredients.count)
            let xPos = ((Float(ingredients.index(of: item)!) * (displacement + 0.05)) + foodBoundingBox.min.x - (displacement + 0.05))
            foodNameNode.position = SCNVector3(xPos, foodItemNode.position.y + 0.15, foodItemNode.position.z)

            wrapperNode.addChildNode(foodNameNode)
        }
        
        return wrapperNode
    }
}

extension MenuPreviewViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("Node Added...")
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let cupNode = loadModel(anchor: planeAnchor)
        node.addChildNode(cupNode!)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("Node Updated...")
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        let cupNode = loadModel(anchor: planeAnchor)
        node.addChildNode(cupNode!)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("Node Removed...")
        guard anchor is ARPlaneAnchor else { return }
        
        // Remove existing plane nodes
        node.enumerateChildNodes {
            (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
}

extension MenuPreviewViewController: ARSessionObserver {
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Failed : \(error)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("Session Interrupted...")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
    }
}
