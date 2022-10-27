//
//  ContentView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MotionViewModel(motionManager: MotionManager())
    
    var body: some View {
        VStack {
            HStack {
                Text("Acceleration")
                Text("\(viewModel.userAcceleration.x, specifier: "%.2f")")
                Text("\(viewModel.userAcceleration.y, specifier: "%.2f")")
                Text("\(viewModel.userAcceleration.z, specifier: "%.2f")")
            }
            HStack {
                Text("RotationRate")
                Text("\(viewModel.rotationRate.x, specifier: "%.2f")")
                Text("\(viewModel.rotationRate.y, specifier: "%.2f")")
                Text("\(viewModel.rotationRate.z, specifier: "%.2f")")
            }
            
            Button {
                self.viewModel.startMonitoring()
            } label: {
                Text("Start Motion Monitoring")
            }
            
            Button {
                self.viewModel.stopMonitoring()
            } label: {
                Text("Stop")
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
