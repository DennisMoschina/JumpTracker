//
//  AttitudeSlidersView.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 03.12.22.
//

import SwiftUI

struct AttitudeSlidersView: View {
    @State var roll: Double = 0
    @State var pitch: Double = 0
    @State var yaw: Double = 0
    
    let onEdit: (_ r: Double, _ p: Double, _ y: Double) -> ()
    
    var body: some View {
        VStack {
            Slider(value: self.$roll, in: -Double.pi...Double.pi) { changed in
                if !changed {
                    self.onEdit(self.roll, self.pitch, self.yaw)
                }
            }
            Slider(value: self.$pitch, in: -Double.pi...Double.pi) { changed in
                if !changed {
                    self.onEdit(self.roll, self.pitch, self.yaw)
                }
            }
            Slider(value: self.$yaw, in: -Double.pi...Double.pi) { changed in
                if !changed {
                    self.onEdit(self.roll, self.pitch, self.yaw)
                }
            }
        }.padding()
    }
}

struct AttitudeSlidersView_Previews: PreviewProvider {
    static var previews: some View {
        AttitudeSlidersView(onEdit: { x, y, z in return })
    }
}
