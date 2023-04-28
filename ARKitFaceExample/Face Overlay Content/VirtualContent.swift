/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Manages virtual overlays diplayed on the face in the AR experience.
*/

import ARKit
import SceneKit

// modify the user interface control bar targets here

enum VirtualContentType: Int {
    // case transforms, texture, geometry, videoTexture, blendShape
    case dark
    
    func makeController() -> VirtualContentController {
        switch self {
        // case .transforms:
        case .dark:
            // return TransformVisualization()
            
            return TexturedFaceDarkBG()
        // case .texture:
       // case .green:
            
           // return TexturedFace()
            
        // case .geometry:
        // case .light:
            // return FaceOcclusionOverlay()
            
           // return TexturedFaceLightBG()
        // case .videoTexture:
            // return VideoTexturedFace()
        // case .blendShape:
            // return BlendShapeCharacter()
        }
    }
}

/// For forwarding `ARSCNViewDelegate` messages to the object controlling the currently visible virtual content.
protocol VirtualContentController: ARSCNViewDelegate {
    /// The root node for the virtual content.
    var contentNode: SCNNode? { get set }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor)
}
