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

    /// Execute the script at the provided URL.
    static func executePowerMetrics() async throws -> String {
        return try await HelperRemoteProvider.remote().executeCmd()
    }
}
