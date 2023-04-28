//
//  TexturedFaceDarkBG.swift
//  ARKitFaceExample
//
//  Created by eightifact on 4/28/23.
//  Copyright © 2023 Apple. All rights reserved.
//

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Displays the 3D face mesh geometry provided by ARKit, with a static texture.
*/

import ARKit
import SceneKit

class TexturedFaceDarkBG : NSObject, VirtualContentController {

    var contentNode: SCNNode?
    var eyeNode: SCNNode?
    

    
    // Load multiple copies of the axis origin visualization for the transforms this class visualizes.
    lazy var rightEyeNode = SCNReferenceNode(named: "eyeOrigin")
    lazy var leftEyeNode = SCNReferenceNode(named: "eyeOrigin")
    
    
    
    /// - Tag: CreateARSCNFaceGeometry
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let sceneView = renderer as? ARSCNView,
            anchor is ARFaceAnchor else { return nil }
        
        #if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
        #else
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
        let material = faceGeometry.firstMaterial!
        
        material.diffuse.contents = #imageLiteral(resourceName: "goldFaceTexture") // Example texture map image.
        material.lightingModel = .physicallyBased
        
        contentNode = SCNNode(geometry: faceGeometry)
        
        // Load an asset from the app bundle to provide visual content for the anchor.
        eyeNode = SCNReferenceNode(named: "eyeOrigin")
        
        let glassesNode = SCNReferenceNode(named: "sunGlasses")
        glassesNode.childNode(withName: "specs", recursively: true)
        let mouthBGNode = SCNReferenceNode(named: "mouthBG")
        mouthBGNode.childNode(withName: "sphere", recursively: true)
        
        contentNode!.addChildNode(glassesNode)
        contentNode!.addChildNode(mouthBGNode)
        
        
        
        // Add content for eye tracking in iOS 12.
        self.addEyeTransformNodes()
                
        #endif
        return contentNode
        
        
    }
    
    /// - Tag: ARFaceGeometryUpdate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
        rightEyeNode.simdTransform = faceAnchor.rightEyeTransform
        leftEyeNode.simdTransform = faceAnchor.leftEyeTransform
    }
    
    func addEyeTransformNodes() {
        guard #available(iOS 12.0, *), let anchorNode = contentNode else { return }
        
        // Scale down the coordinate axis visualizations for eyes.
        rightEyeNode.simdPivot = float4x4(diagonal: [3, 3, 3, 1])
        leftEyeNode.simdPivot = float4x4(diagonal: [3, 3, 3, 1])
        
        // Reposition the eye model.
        //rightEyeNode.position.z = -10
        // leftEyeNode.position.z = -5
        // leftEyeNode.position.z = -5
        
        anchorNode.addChildNode(rightEyeNode)
        anchorNode.addChildNode(leftEyeNode)
    }
    

}

