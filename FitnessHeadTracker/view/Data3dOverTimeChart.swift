//
//  AccelerationChart.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import SwiftUI
import Charts

typealias Chart3dDataOverTime = [(axis: String, data: [Double])]

struct Data3dOverTimeChart: View {
    @ObservedObject var motionViewModel: MotionViewModel
    
    let dataKeyPath: KeyPath<MotionViewModel, Chart3dDataOverTime>
    
    var body: some View {
        ZStack {
            GroupBox {
                Chart {
                    ForEach(self.motionViewModel[keyPath: self.dataKeyPath], id: \.axis) { item in
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
    var historicUserActionChartAccessible: Chart3dDataOverTime {
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
    
    var historicRotationRateChartAccessible: Chart3dDataOverTime {
        return [
            (
                axis: "X",
                data: self.historicRotationRate.map { (rotationRate: RotationRate, timestamp: Double) in
                    rotationRate.x
                }
            ),
            (
                axis: "Y",
                data: self.historicRotationRate.map { (rotationRate: RotationRate, timestamp: Double) in
                    rotationRate.y
                }
            ),
            (
                axis: "Z",
                data: self.historicRotationRate.map { (rotationRate: RotationRate, timestamp: Double) in
                    rotationRate.z
                }
            ),
        ]
    }
    
    var historicAttitudeChartAccessible: Chart3dDataOverTime {
        return [
            (
                axis: "roll",
                data: self.historicAttitude.map { (attitude: Attitude, timestamp: Double) in
                    attitude.roll
                }
            ),
            (
                axis: "pitch",
                data: self.historicAttitude.map { (attitude: Attitude, timestamp: Double) in
                    attitude.pitch
                }
            ),
            (
                axis: "yaw",
                data: self.historicAttitude.map { (attitude: Attitude, timestamp: Double) in
                    attitude.yaw
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
            Data3dOverTimeChart(motionViewModel: MotionViewModel(motionManager: motionManager), dataKeyPath: \.historicUserActionChartAccessible)
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
