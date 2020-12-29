//
//  ViewController.swift
//  MagicNewsPaperAppiOS13-14
//
//  Created by Sonali Patel on 12/29/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let referenceImage =  ARReferenceImage.referenceImages(inGroupNamed: "NewspaperImages", bundle: Bundle.main) {
            configuration.trackingImages = referenceImage
            configuration.maximumNumberOfTrackedImages = 1
            print("Images successfully found")
        } else {
            print("Problem getting ARReferenceImage from Assets.xcassets folder")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            print(imageAnchor)
            
            let videoNode = SKVideoNode(fileNamed: "HarryPotter.mp4")
            
            videoNode.play()
            
            let screenRect = UIScreen.main.bounds
            let screenWidth = screenRect.size.width
            let screenHeight = screenRect.size.height
            
            let videoScene = SKScene(size: CGSize(width: screenWidth, height: screenHeight))
            
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            
            videoNode.yScale = -1.0
            
            videoScene.addChild(videoNode)
            
            let planeGeometry = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.width)
            
            planeGeometry.firstMaterial?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: planeGeometry)
            
            planeNode.eulerAngles.x = -Float.pi/2
            
            node.addChildNode(planeNode)

        }
        
        return node
    }
}
