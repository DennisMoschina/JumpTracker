//
//  YawIndicator.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 03.12.22.
//

import SwiftUI

struct YawIndicator: View {
    @ObservedObject var motionViewModel: MotionViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            ZStack(alignment: .top) {
                Circle()
                    .frame(width: size)
                    .foregroundColor(.blue)
                    .mask {
                        Circle()
                            .padding(40)
                            .foregroundColor(.black)
                            .background(.white)
                            .compositingGroup()
                            .luminanceToAlpha()
                    }
                Rectangle().frame(width: 20, height: 40)
            }
            .rotationEffect(Angle(radians: self.motionViewModel.attitude.yaw))
        }
    }
}

struct YawIndicator_Previews: PreviewProvider {
    static let motionManager: MotionManagerMock = MotionManagerMock()
    
    static var previews: some View {
        VStack {
            YawIndicator(motionViewModel: MotionViewModel(motionManager: motionManager))
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
