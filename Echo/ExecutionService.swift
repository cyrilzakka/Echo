//
//  ExecutionService.swift
//  Echo
//
//  Created by Cyril Zakka on 10/12/24.
//

import Foundation

// MARK: - ExecutionService

/// Execute a script.
enum ExecutionService {

    // MARK: Execute
    static func startStreamingPowerMetrics(updateHandler: @escaping (String) -> Void) async throws {
        let helper = try await HelperRemoteProvider.remote()
        helper.startStreamingPowerMetrics { output in
            print("Received: \(output)")
            DispatchQueue.main.async {
                updateHandler(output)
            }
        }
    }
    
    /// Stop streaming powermetrics data
    static func stopStreamingPowerMetrics() async throws {
        let helper = try await HelperRemoteProvider.remote()
        helper.stopStreamingPowerMetrics()
    }
}
