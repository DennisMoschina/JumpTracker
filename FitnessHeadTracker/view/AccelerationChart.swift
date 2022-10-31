//
//  AccelerationChart.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import SwiftUI
import Charts

struct AccelerationChart: View {
    @ObservedObject var motionViewModel: MotionViewModel
    
    var body: some View {
        ZStack {
            GroupBox {
                Chart {
                    ForEach(Array(self.motionViewModel.historicUserAccel.enumerated()), id: \.offset) { item in
                        LineMark(
                            x: .value("Time", item.offset),
                            y: .value("X", item.element.acceleration.x)
                        )
                    }
                }
                .chartYScale(domain: -1...1)
            }
            .padding()
        }
    }
}

// MARK: - Preview

struct AccelerationChart_Previews: PreviewProvider {
    static let motionManager: MotionManagerMock = MotionManagerMock()
    
    static var previews: some View {
        VStack {
            AccelerationChart(motionViewModel: MotionViewModel(motionManager: motionManager))
            Spacer()
            HStack {
                Button("Start") {
                    motionManager.start()
                }
                Button("Stop") {
                    motionManager.stop()
                }
            }
            SliderView { acceleration in
                self.motionManager.update(acceleration: acceleration)
            }
        }
    }
}

struct SliderView: View {
    @State var accX: Double = 0
    @State var accY: Double = 0
    @State var accZ: Double = 0
    
    var acceleration: Acceleration {
        Acceleration(x: accX, y: accY, z: accZ)
    }
    
    let onEdit: (Acceleration) -> ()

    var body: some View {
        VStack {
            Slider(value: $accX, in: -2...2) { changed in
                if changed {
                    self.onEdit(self.acceleration)
                }
            }
            Slider(value: $accY, in: -2...2) { changed in
                if changed {
                    self.onEdit(self.acceleration)
                }
            }
            Slider(value: $accZ, in: -2...2) { changed in
                if changed {
                    self.onEdit(self.acceleration)
                }
            }
        }.padding()
    }
    
}
