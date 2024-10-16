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
    static func streamPowerMetrics() async throws -> PowerMetricsSequence {
        let helper = try await HelperRemoteProvider.remote()
        return PowerMetricsSequence(helper: helper)
    }
    
    static func stopStreamingPowerMetrics() async throws {
        let helper = try await HelperRemoteProvider.remote()
        helper.stopStreamingPowerMetrics()
    }
}
