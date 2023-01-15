//
//  RecordingChart.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 15.01.23.
//

import SwiftUI

fileprivate enum ViewSeletion: Identifiable, CaseIterable {
    var id: Self { self }
    
    case ACCEL
    case ROT_RATE
    case ATT
    
    var name: String {
        var name: String
        switch self {
        case .ACCEL:
            name = "Acceleration"
        case .ROT_RATE:
            name = "RotationRate"
        case .ATT:
            name = "Attitude"
        }
        
        return name
    }
}

struct RecordingChartsView: View {
    @ObservedObject var recordingViewModel: RecordingViewModel
    @State private var selectedChart: ViewSeletion = .ACCEL
    
    var body: some View {
        VStack {
            Picker("Chart", selection: self.$selectedChart) {
                ForEach(ViewSeletion.allCases) { selection in
                    Text(selection.name)
                }
            }.pickerStyle(.segmented)
            
            switch self.selectedChart {
            case .ACCEL:
                RecordingChart(chartData: self.recordingViewModel.accelerationChartData)
            case .ROT_RATE:
                RecordingChart(chartData: self.recordingViewModel.rotationRateChartData)
            case .ATT:
                RecordingChart(chartData: self.recordingViewModel.attitudeChartData)
            }
        }
    }
}

struct RecordingChartsView_Previews: PreviewProvider {
    static var recording: Recording = (PersistenceController.preview.container.viewContext.registeredObjects.first as? Recording)!
    
    static var previews: some View {
        RecordingChartsView(recordingViewModel: RecordingViewModel(recording: self.recording))
    }
}
