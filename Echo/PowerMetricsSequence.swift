//
//  PowerMetricsSequence.swift
//  Echo
//
//  Created by Cyril Zakka on 10/15/24.
//

import Foundation

struct PowerMetricsSequence: AsyncSequence {
    typealias Element = String
    
    let helper: HelperProtocol
    
    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(helper: helper)
    }
    
    class AsyncIterator: AsyncIteratorProtocol {
        let helper: HelperProtocol
        private var continuation: CheckedContinuation<String?, Error>?
        private var isFinished = false
        
        init(helper: HelperProtocol) {
            self.helper = helper
        }
        
        func next() async throws -> String? {
            if isFinished {
                return nil
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                
                helper.startStreamingPowerMetrics { output in
                    continuation.resume(returning: output)
                    self.continuation = nil
                }
            }
        }
        
        func cancel() {
            isFinished = true
            helper.stopStreamingPowerMetrics()
            continuation?.resume(returning: nil)
        }
    }
}
