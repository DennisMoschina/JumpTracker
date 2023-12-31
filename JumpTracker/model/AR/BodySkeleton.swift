//
//  BodySkeleton.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 21.06.23.
//

import Foundation
import RealityKit
import ARKit

class BodySkeleton: Entity {
    @Published var joints: [String : Entity] = [:]
    @Published var bones: [String : Entity] = [:]
    @Published var bodyAnchor: ARBodyAnchor
    @Published var anchorPosition: SIMD3<Float> = .init()
    
    var onUpdate: (ARBodyAnchor) -> Void = { _ in return }
    
    required init(for bodyAnchor: ARBodyAnchor) {
        self.bodyAnchor = bodyAnchor
        super.init()
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            var jointRadius: Float = 0.05
            var jointColor: UIColor = .green
            
            switch jointName {
            case "neck_1_joint", "neck_2_joint", "neck_3_joint", "neck_4_joint", "head_joint", "left_shoulder_1_joint", "right_shoulder_1_joint":
                jointRadius *= 0.5
            case "jaw_joint", "chin_joint", "left_eye_joint", "left_eyeLowerlid_joint", "left_eyeUpperLid_joint", "left_eyeball_joint", "nose_joint", "right_eye_joint", "right_eyeLowerLid_joint", "right_eyeUpperLid_joint", "right_eyeball_joint":
                jointRadius *= 0.2
                jointColor = .yellow
            case _ where jointName.hasPrefix("spine_"):
                jointRadius *= 0.75 case "left_hand_joint", "right_hand_joint":
                jointRadius *= 1
                jointColor = .green
            case _ where jointName.hasPrefix("left_hand") || jointName.hasPrefix("right_hand"):
                jointRadius *= 0.25
                jointColor = .yellow
            case _ where jointName.hasPrefix("left_toes") || jointName.hasPrefix("right_toes"):
                jointRadius *= 0.5
                jointColor = .yellow
            default:
                jointRadius = 0.05
                jointColor = .green
            }
            
            let jointEntity = createJoint(radius: jointRadius, color: jointColor)
            self.joints[jointName] = jointEntity
            self.addChild(jointEntity)
            
            for bone in Bones.allCases {
                guard let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor) else { continue }
                
                let boneEntity = createBoneEntity(for: skeletonBone)
                bones[bone.name] = boneEntity
                self.addChild(boneEntity)
            }
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func update(with bodyAnchor: ARBodyAnchor) {
        self.onUpdate(bodyAnchor)
        self.bodyAnchor = bodyAnchor
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        self.anchorPosition = rootPosition
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if
                let jointEntity = joints[jointName],
                let jointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName))
            {
                let jointEntityOffsetFromRoot = simd_make_float3(jointEntityTransform.columns.3) // relative to root
                jointEntity.position = jointEntityOffsetFromRoot + rootPosition // relative to world reference frame
                jointEntity.orientation = Transform(matrix: jointEntityTransform).rotation
            }
        }
        
        for bone in Bones.allCases {
            let boneName = bone.name
            guard
                let entity = self.bones[boneName],
                let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor)
            else { continue }
            entity.position = skeletonBone.centerPosition
            entity.look(at: skeletonBone.toJoint.position, from: skeletonBone.centerPosition, relativeTo: nil) // set orientation for bone
        }
    }
    
    private func createJoint(radius: Float, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, roughness: 0.8, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
    
    private func createSkeletonBone(bone: Bones, bodyAnchor: ARBodyAnchor) -> SkeletonBone? {
        guard
            let fromJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointToName)),
            let toJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointToName))
        else {
            return nil
        }
        
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        let jointFromEntityOffsetFromRoot = simd_make_float3(fromJointEntityTransform.columns.3) // relative to root (i.e. hipjoint)
        let jointFromEntityPosition = jointFromEntityOffsetFromRoot + rootPosition // relative to world reference frame
        
        let jointToEntityOffsetFromRoot = simd_make_float3(toJointEntityTransform.columns.3) // relative to root (i.e. hipjoint)
        let jointToEntityPosition = jointToEntityOffsetFromRoot + rootPosition // relative to world reference frame
        
        let fromJoint = SkeletonJoint (name: bone.jointFromName, position: jointFromEntityPosition)
        let toJoint = SkeletonJoint (name: bone.jointToName, position: jointToEntityPosition)
        return SkeletonBone(fromJoint: fromJoint, toJoint: toJoint)
    }
    
    private func createBoneEntity(for skeletonBone: SkeletonBone, diameter: Float = 0.04, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateBox(size: [diameter, diameter, skeletonBone.length], cornerRadius: diameter / 2)
        let material = SimpleMaterial (color: color, roughness: 0.5, isMetallic: true)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
}
