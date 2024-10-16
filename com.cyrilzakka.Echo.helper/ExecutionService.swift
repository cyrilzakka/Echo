//
//  ExecutionService.swift
//  com.cyrilzakka.Echo.helper
//
//  Created by Cyril Zakka on 10/12/24.
//

import Foundation

enum ExecutionService {
    
    static func streamPowerMetrics(updateHandler: @escaping (String) -> Void) -> Process {
        NSLog("🟠Starting powermetrics streaming")
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/powermetrics")
        process.arguments = [
            "-s", "cpu_power,gpu_power,thermal,network,disk",
            "--show-process-gpu",
            "--show-process-energy",
            "--show-initial-usage",
            "--show-process-netstats",
            "-i", "1000"
        ]
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = outputPipe
        
        let outHandle = outputPipe.fileHandleForReading
        
        outHandle.readabilityHandler = { fileHandle in
            autoreleasepool {
                do {
                    let data = fileHandle.availableData
                    if data.count > 0 {
                        if let output = String(data: data, encoding: .utf8) {
                            NSLog("🟢 Received powermetrics output: %@", output)
                            updateHandler(output)
                        } else {
                            throw NSError(domain: "com.cyrilzakka.Echo.helper", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert powermetrics output to string"])
                        }
                    } else {
                        NSLog("🟠 Received EOF from powermetrics, ending read")
                        fileHandle.readabilityHandler = nil
                        process.terminate()
                    }
                } catch {
                    NSLog("🔴 Error processing powermetrics output: %@", error.localizedDescription)
                    fileHandle.readabilityHandler = nil
                    process.terminate()
                }
            }
        }
        
        do {
            try process.run()
            NSLog("🟠Powermetrics process started")
        } catch {
            NSLog("🔴 Error starting powermetrics process: %@", error.localizedDescription)
        }
        
        return process
    }
}
