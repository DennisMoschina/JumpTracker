//
//  HeadingView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 01.11.22.
//

import SwiftUI

struct HeadingView: View {
    @ObservedObject var motionViewModel: MotionViewModel
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "arrow.right")
                    .rotationEffect(Angle(radians: -self.motionViewModel.attitude.pitch))
                    .font(.largeTitle)
                    .padding(5)
                Text("\(self.motionViewModel.attitude.pitch, specifier: "%.2f")")
                Text("Pitch")
                    .padding(5)
            }
            VStack {
                Image(systemName: "arrow.up")
                    .rotationEffect(Angle(radians: self.motionViewModel.attitude.roll))
                    .font(.largeTitle)
                    .padding(5)
                Text("\(self.motionViewModel.attitude.roll, specifier: "%.2f")")
                Text("Roll")
                    .padding(5)
            }
            VStack {
                Image(systemName: "arrow.up")
                    .rotationEffect(Angle(radians: -self.motionViewModel.attitude.yaw))
                    .font(.largeTitle)
                    .padding(5)
                Text("\(self.motionViewModel.attitude.yaw, specifier: "%.2f")")
                Text("Yaw")
                    .padding(5)
            }
        }
    }
}

struct HeadingView_Previews: PreviewProvider {
    static let motionManager: MotionManagerMock = MotionManagerMock()
    
    static var previews: some View {
        VStack {
            HeadingView(motionViewModel: MotionViewModel(motionManager: self.motionManager))
            
            HStack {
                Button("Start") {
                    self.motionManager.start()
                }
                Button("Stop") {
                    self.motionManager.stop()
                }
            }
            MotionSlidersView { x, y, z in
                self.motionManager.update(attitude: SIMDAttitude(roll: x, pitch: y, yaw: z))
            }
        }
    }
}
