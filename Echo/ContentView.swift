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
            Button(viewModel.isStreaming ? "Stop Streaming" : "Start Streaming") {
                if viewModel.isStreaming {
                    viewModel.stopStreaming()
                } else {
                    viewModel.startStreaming()
                }
            }
        }
        .padding()
    }
}

@MainActor
class ContentViewModel: ObservableObject {
    @Published var scriptOutput = ""
    @Published var isStreaming = false
    
    private var streamTask: Task<Void, Error>?
    
    private var iterator: PowerMetricsSequence.AsyncIterator?
    
    func startStreaming() {
        guard !isStreaming else { return }
        
        isStreaming = true
        streamTask = Task {
            do {
                let sequence = try await ExecutionService.streamPowerMetrics()
                var iterator = sequence.makeAsyncIterator()
                self.iterator = iterator
                while let output = try await iterator.next() {
                    scriptOutput = output
                }
            } catch {
                scriptOutput = error.localizedDescription
            }
            isStreaming = false
        }
    }
    
    func stopStreaming() {
        streamTask?.cancel()
        iterator?.cancel()
        iterator = nil
        streamTask = nil
        isStreaming = false
        
        Task {
            try? await ExecutionService.stopStreamingPowerMetrics()
        }
    }
}

#Preview {
    ContentView()
}
