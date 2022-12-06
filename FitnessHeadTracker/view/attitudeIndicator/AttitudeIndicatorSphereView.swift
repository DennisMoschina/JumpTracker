//
//  AttitudeIndicatorSphereView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 03.12.22.
//

import SwiftUI
import SceneKit
import Combine

struct AttitudeIndicatorSphereView: View {
    @ObservedObject var motionViewModel: MotionViewModel
    @State var scene: AttitudeIndicatorScene = AttitudeIndicatorScene()
    
    var body: some View {
        self.scene.rotateSphere(to: self.motionViewModel.attitude)
        
        return SceneView(
            scene: self.scene,
            options: [
                .autoenablesDefaultLighting,
                .temporalAntialiasingEnabled
            ]
        )
    }
}

struct AttitudeIndicatorSphereView_Previews: PreviewProvider {
    static let motionManager: MotionManagerMock = MotionManagerMock()
    
    static var previews: some View {
        VStack {
            GroupBox {
                AttitudeIndicatorSphereView(motionViewModel: MotionViewModel(motionManager: motionManager))
                    .frame(width: 300, height: 300)
            }
            Spacer()
            HStack {
                Button("Start") {
                    motionManager.start()
                }
                Button("Stop") {
                    motionManager.stop()
                }
            }
            AttitudeSlidersView { x, y, z in
                self.motionManager.update(attitude: SIMDAttitude(roll: x, pitch: y, yaw: z))
            }
        }
    }
}
