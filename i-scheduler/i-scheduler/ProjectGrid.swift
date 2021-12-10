//
//  ProjectGrid.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/08.
//

import SwiftUI


// Temporary Project Grid View...

struct ProjectGrid: View {
    
    @State var row: String = ""
    
    var body: some View {
        Text("row \(row)...")
    }
}

struct ProjectGrid_Previews: PreviewProvider {
    static var previews: some View {
        ProjectGrid()
    }
}
