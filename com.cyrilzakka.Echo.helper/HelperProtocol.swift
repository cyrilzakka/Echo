//
//  HelperProtocol.swift
//  Echo
//
//  Created by Cyril Zakka on 10/12/24.
//

import Foundation

@objc public protocol HelperProtocol {
    @objc func executeCmd() async throws -> String
    @objc func startStreamingPowerMetrics(updateHandler: @escaping (String) -> Void)
    @objc func stopStreamingPowerMetrics()
}
