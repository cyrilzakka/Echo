//
//  ContentView.swift
//  Echo
//
//  Created by Cyril Zakka on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                Text(viewModel.scriptOutput)
            }
            Button("Stop Streaming") {
                if viewModel.isStreaming {
                    viewModel.stopStreaming()
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.startStreaming()
        }
    }
}

class ContentViewModel: ObservableObject {
    @Published var scriptOutput = ""
    @Published var isStreaming = false
    
    func startStreaming() {
        Task {
            do {
                try await ExecutionService.startStreamingPowerMetrics { [weak self] output in
                    DispatchQueue.main.async {
                        print(output)
                        self?.scriptOutput = output
                    }
                }
                await MainActor.run { self.isStreaming = true }
            } catch {
                await MainActor.run { self.scriptOutput = error.localizedDescription }
            }
        }
    }
    
    func stopStreaming() {
        Task {
            do {
                try await ExecutionService.stopStreamingPowerMetrics()
                await MainActor.run { self.isStreaming = false }
            } catch {
                await MainActor.run { self.scriptOutput = error.localizedDescription }
            }
        }
    }
}

#Preview {
    ContentView()
}
