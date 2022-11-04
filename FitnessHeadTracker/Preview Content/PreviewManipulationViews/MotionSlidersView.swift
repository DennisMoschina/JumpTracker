//
//  MotionSlidersView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 01.11.22.
//

import SwiftUI

struct MotionSlidersView: View {
    @State var accX: Double = 0
    @State var accY: Double = 0
    @State var accZ: Double = 0
    
    let onEdit: (_ x: Double, _ y: Double, _ z: Double) -> ()
    
    var body: some View {
        VStack {
            Slider(value: self.$accX, in: -2...2) { changed in
                if !changed {
                    self.onEdit(self.accX, self.accY, self.accZ)
                }
            }
            Slider(value: self.$accY, in: -2...2) { changed in
                if !changed {
                    self.onEdit(self.accX, self.accY, self.accZ)
                }
            }
            Slider(value: self.$accZ, in: -2...2) { changed in
                if !changed {
                    self.onEdit(self.accX, self.accY, self.accZ)
                }
            }
        }.padding()
    }
}

struct MotionSlidersView_Previews: PreviewProvider {
    static var previews: some View {
        MotionSlidersView(onEdit: { x,y,z in return })
    }
}
