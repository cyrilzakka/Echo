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
        private let helper: HelperProtocol
        private var continuations: [CheckedContinuation<String?, Error>] = []
        private var isStreaming = false
        private var isFinished = false
        
        init(helper: HelperProtocol) {
            self.helper = helper
        }
        
        func next() async throws -> String? {
            print("NEXT")
            if isFinished {
                return nil
            }
            
            if !isStreaming {
                print("isStreaming")
                isStreaming = true
                helper.startStreamingPowerMetrics { [weak self] output in
                    guard let self = self else { return }
                    print("my output: \(output)")
                    if let continuation = self.continuations.first {
                        self.continuations.removeFirst()
                        continuation.resume(returning: output)
                    }
                }
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                continuations.append(continuation)
            }
        }
        
        func cancel() {
            isFinished = true
            helper.stopStreamingPowerMetrics()
            for continuation in continuations {
                continuation.resume(returning: nil)
            }
            continuations.removeAll()
        }
    }
}
