//
//  AttitudeIndicatorScene.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 03.12.22.
//

import SceneKit
import SpriteKit
import Foundation
import simd

class AttitudeIndicatorScene: SCNScene {
    private static let TRANSFORM_QUATERNION: Quaternion = SIMDQuaternion(from: simd_float3(x: 0, y: 1, z: 0),
                                                                         to: simd_float3(x: 0, y: 0, z: -1))
    private static func buildSphereNode() -> SCNNode {
        let sphere: SCNSphere = SCNSphere(radius: 1)
        
        sphere.firstMaterial?.diffuse.contents = SKScene(fileNamed: "AttitudeSphereTexture")
        
        let sphereNode: SCNNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)

        return sphereNode
    }
    
    private var cameraNode: SCNNode {
        let cameraDistance: Float = 3
        let fov: Float = asin(1.0 / cameraDistance) * 360 / Float.pi
        
        let camera: SCNCamera = SCNCamera()
        camera.fieldOfView = CGFloat(fov)
        
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: cameraDistance)
        return cameraNode
    }
    
    private var sphereNode: SCNNode = buildSphereNode()
    
    override init() {
        super.init()
        
        self.build()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.build()
    }
    
    public func rotateSphere(to attitude: any Attitude) {
        self.sphereNode.simdLocalRotate(by: self.getRelativeRotation(for: self.sphereNode, by: attitude))
    }
    
    private func build() {
        self.rootNode.addChildNode(self.sphereNode)
        self.rootNode.addChildNode(self.cameraNode)
    }
    
    private func getRelativeRotation(for node: SCNNode, by attitude: any Attitude) -> simd_quatf {
        let currentOrientation: simd_quatf = node.simdWorldOrientation
        let resetOrientation: simd_quatf = currentOrientation.inverse
        let desiredOrentation: simd_quatf = simd_quatf(Self.TRANSFORM_QUATERNION) * simd_quatf(attitude)
        
        let result: simd_quatf = resetOrientation * desiredOrentation * simd_quatf(angle: Float.pi / 2, axis: simd_float3(x: 1, y: 0, z: 0))

        return result
    }
}
