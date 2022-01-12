//
//  ContentView.swift
//  i-scheduler
//
//  Created by 권은빈 on 2021/12/06.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            MainCalendar()
            ProjectList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
