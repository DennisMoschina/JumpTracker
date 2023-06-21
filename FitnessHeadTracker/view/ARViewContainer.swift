//
//  ARViewContainer.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 21.06.23.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

private var bodySkeleton: BodySkeleton?
private let bodySkeletonAnchor = AnchorEntity()

struct ARViewContainer: UIViewRepresentable {
    @State var character: BodyTrackedEntity?
    let characterAnchor = AnchorEntity()
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        arView.setupForBodyTracking()
        arView.scene.addAnchor(bodySkeletonAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}

extension ARView: ARSessionDelegate {
    func setupForBodyTracking() {
        let configuration = ARBodyTrackingConfiguration()
        self.session.run(configuration)
        
        self.session.delegate = self
    }
    
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
                if let skeleton = bodySkeleton {
                    // BodySkeleton already exists, update all joints and bones
                    skeleton.update (with: bodyAnchor)
                } else {
                    // BodySkeleton doesn't yet exist. This means a body has been detected for the first time.
                    // Create bodySkeleton entity and add it to the bodySkeletonAnchor
                    bodySkeleton = BodySkeleton (for: bodyAnchor)
                    bodySkeletonAnchor.addChild(bodySkeleton!)
                }
            }
        }
    }
}

struct ARViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        ARViewContainer()
    }
}
