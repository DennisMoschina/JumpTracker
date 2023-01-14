//
//  ValuesView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 14.01.23.
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

struct ValuesView: View {
    @State private var selected: ViewSeletion = .ACCEL
    
    @ObservedObject var viewModel: MotionViewModel
    
    
    var body: some View {
        GroupBox {
            Picker("Chart", selection: self.$selected) {
                ForEach(ViewSeletion.allCases) { view in
                    Text(view.name)
                }
            }.pickerStyle(.segmented)
            
            Group {
                switch self.selected {
                case .ACCEL:
                    Data3dOverTimeChart(motionViewModel: self.viewModel, dataKeyPath: \.historicUserActionChartAccessible)
                case .ROT_RATE:
                    Data3dOverTimeChart(motionViewModel: self.viewModel, dataKeyPath: \.historicRotationRateChartAccessible)
                case .ATT:
                    Data3dOverTimeChart(motionViewModel: self.viewModel, dataKeyPath: \.historicAttitudeChartAccessible)
                }
            }
        }
    }
}

struct ValuesView_Previews: PreviewProvider {
    static var previews: some View {
        ValuesView(viewModel: MotionViewModel(motionManager: MotionManagerMock()))
    }
}
