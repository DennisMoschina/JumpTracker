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
                    ForEach(self.motionViewModel.historicUserActionChartAccessible, id: \.axis) { item in
                        ForEach(Array(item.data.enumerated()), id: \.offset) { (index, dataElement) in
                            LineMark(
                                x: .value("Time", index),
                                y: .value("Data", dataElement)
                            )
                        }
                        .foregroundStyle(by: .value("Axis", item.axis))
                    }
                }
                .chartYScale(domain: -1...1)
            }
            .padding()
            
            
            // TODO: remove
            Text("\(self.motionViewModel.rotationRate.x)")
                .opacity(0)
        }
    }
}



// MARK: - ViewModel Extension

extension MotionViewModel {
    var historicUserActionChartAccessible: [(axis: String, data: [Double])] {
        return [
            (
                axis: "X",
                data: self.historicUserAccel.map { (acceleration: Acceleration, timestamp: Double) in
                    acceleration.x
                }
            ),
            (
                axis: "Y",
                data: self.historicUserAccel.map { (acceleration: Acceleration, timestamp: Double) in
                    acceleration.y
                }
            ),
            (
                axis: "Z",
                data: self.historicUserAccel.map { (acceleration: Acceleration, timestamp: Double) in
                    acceleration.z
                }
            ),
        ]
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
            MotionSlidersView { x, y, z in
                self.motionManager.update(acceleration: SIMDAcceleration(x: x, y: y, z: z))
            }
        }
    }
}
