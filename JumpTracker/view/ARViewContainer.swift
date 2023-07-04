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


struct ARViewContainer: UIViewRepresentable {
    @State internal var bodySkeleton: BodySkeleton? {
        didSet {
            if let bodySkeleton {
                self.onSkeletonCreate(bodySkeleton)
            }
        }
    }
    internal let bodySkeletonAnchor = AnchorEntity()
    
    var onSkeletonCreate: (BodySkeleton) -> Void = { _ in return }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        arView.session.delegate = context.coordinator
        
        arView.scene.addAnchor(bodySkeletonAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        private let parent: ARViewContainer
        
        init(parent: ARViewContainer) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                if let bodyAnchor = anchor as? ARBodyAnchor {
                    if let skeleton = self.parent.bodySkeleton {
                        // BodySkeleton already exists, update all joints and bones
                        skeleton.update(with: bodyAnchor)
                    } else {
                        // BodySkeleton doesn't yet exist. This means a body has been detected for the first time.
                        // Create bodySkeleton entity and add it to the bodySkeletonAnchor
                        self.parent.bodySkeleton = BodySkeleton(for: bodyAnchor)
                        self.parent.bodySkeletonAnchor.addChild(self.parent.bodySkeleton!)
                    }
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
