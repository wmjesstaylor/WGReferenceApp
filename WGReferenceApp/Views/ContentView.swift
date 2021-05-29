//
//  ContentView.swift
//  WGReferenceApp
//
//  Created by Jess Taylor on 5/24/21.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            WGView()
        }
    }
}
