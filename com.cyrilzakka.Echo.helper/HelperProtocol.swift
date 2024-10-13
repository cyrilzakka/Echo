//
//  HelperProtocol.swift
//  Echo
//
//  Created by Cyril Zakka on 10/12/24.
//

import Foundation

@objc(HelperProtocol)
public protocol HelperProtocol {
    @objc func executeCmd() async throws -> String
}
