//
//  AttitudeIndicator.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 03.12.22.
//

import SwiftUI

struct AttitudeIndicator: View {
    @ObservedObject var motionViewModel: MotionViewModel
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack(alignment: .center) {
                AttitudeIndicatorSphereView(motionViewModel: self.motionViewModel)
                    .padding(45)
                YawIndicator(motionViewModel: self.motionViewModel)
            }
            .frame(width: min(geometryReader.size.width, geometryReader.size.height),
                   height: min(geometryReader.size.width, geometryReader.size.height))
        }
    }
}

struct AttitudeIndicator_Previews: PreviewProvider {
    static let motionManager: MotionManagerMock = MotionManagerMock()
    
    static var previews: some View {
        VStack {
            AttitudeIndicator(motionViewModel: MotionViewModel(motionManager: motionManager))
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
