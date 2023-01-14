//
//  BluetoothView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 11.12.22.
//

import SwiftUI

struct DistanceView: View {
    @ObservedObject var distanceTrackerViewModel: AbsoluteDistanceTrackerViewModel
    
    var body: some View {
        VStack {
            Text("\(self.distanceTrackerViewModel.distance.distance)")
                .alert("Failed to connect", isPresented: self.$distanceTrackerViewModel.failed) {
                    Button("Try again") {
                        #warning("TODO: implement")
                    }
                }
            
            Button("start") {
                self.distanceTrackerViewModel.start()
            }
            
            Button("stop") {
                self.distanceTrackerViewModel.stop()
            }
        }
    }
}

struct BluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceView(distanceTrackerViewModel: AbsoluteDistanceTrackerViewModel(trackerFactory: RSSIBasedAbsoluteDistanceTrackerFactory(bleManager: BLEManager.Singleton)))
    }
}
