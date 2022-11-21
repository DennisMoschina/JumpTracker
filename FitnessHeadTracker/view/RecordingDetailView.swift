//
//  RecordingsDetailView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 17.11.22.
//

import SwiftUI
import Charts

struct RecordingDetailView: View {
    @ObservedObject var viewModel: RecordingViewModel
    
    var body: some View {
        VStack {
            GroupBox {
                Chart {
                    ForEach(self.viewModel.accelerationChartData, id: \.axis) { item in
                        ForEach(Array(item.data.enumerated()), id: \.offset) { (_, data) in
                            LineMark(
                                x: .value("Time", data.timestamp),
                                y: .value("Data", data.data)
                            )
                        }
                        .foregroundStyle(by: .value("Axis", item.axis))
                    }
                }
                .chartYScale(domain: -1...1)
            }.padding()
        }.toolbar {
            ShareLink(item: self.viewModel.recording, preview: SharePreview(""))
        }
    }
}

struct RecordingsDetailView_Previews: PreviewProvider {
    static var recording: Recording {
        let recording = Recording()
        recording.startTime = Date()
        recording.name = "Test recording"
        for i in 0..<10 {
            let motion = CDMotion()
            let acceleration: CDAcceleration = CDAcceleration()
            acceleration.insertData(from: SIMDAcceleration(x: 0.1 * Double(i), y: -0.1 * Double(i), z: 0.05 * Double(i)))
            motion.userAcceleration = acceleration
            recording.addToMotions(motion)
        }
        
        return recording
    }
    
    static var previews: some View {
        RecordingDetailView(viewModel: RecordingViewModel(recording: recording))
    }
}
