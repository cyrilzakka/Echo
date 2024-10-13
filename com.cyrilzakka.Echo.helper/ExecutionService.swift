//
//  ExecutionService.swift
//  com.cyrilzakka.Echo.helper
//
//  Created by Cyril Zakka on 10/12/24.
//

import Foundation

enum ExecutionService {
    
    static func executePowerMetrics() async throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/powermetrics")
        process.arguments = [
            "-s", "cpu_power,gpu_power,thermal,network,disk",
            "--show-process-gpu",
            "--show-process-energy",
            "--show-initial-usage",
            "--show-process-netstats",
            "-i", "1000",
            "-n", "1",
        ]
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = outputPipe
        try process.run()
        
        return try await Task {
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            
            guard let output = String(data: outputData, encoding: .utf8) else {
                throw EchoError.invalidStringConversion
            }
            
            return output
        }
        .value
    }
}
