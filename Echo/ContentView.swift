//
//  ContentView.swift
//  Echo
//
//  Created by Cyril Zakka on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var scriptOutput = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(scriptOutput)
        }
        .padding()
        .onAppear {
            executeScript()
        }
    }
}

extension ContentView {

    @MainActor
    private func executeScript() {
        Task {
            do {
                let result = try await ExecutionService.executePowerMetrics()
                scriptOutput = result
            } catch {
                scriptOutput = error.localizedDescription
            }
        }
    }
}

#Preview {
    ContentView()
}
