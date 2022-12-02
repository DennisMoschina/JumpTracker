//
//  ManageMonitoringButton.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//

import SwiftUI

struct ManageMonitoringButton: View {
    @ObservedObject var viewModel: MotionViewModel
    
    var body: some View {
        Group {
            if self.viewModel.updating {
                Button {
                    self.viewModel.stopMonitoring()
                } label: {
                    Text("Stop Motion Monitoring")
                }
                .tint(.red)
            } else {
                Button {
                    self.viewModel.startMonitoring()
                } label: {
                    Text("Start Motion Monitoring")
                }
            }
        }
        .padding()
        .buttonStyle(.borderedProminent)
    }
}

struct ManageMonitoringButton_Previews: PreviewProvider {
    static var previews: some View {
        ManageMonitoringButton(viewModel: MotionViewModel(motionManager: MotionManager.singleton))
    }
}
