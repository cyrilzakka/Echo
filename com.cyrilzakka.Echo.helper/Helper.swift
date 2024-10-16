//
//  Helper.swift
//  com.cyrilzakka.Echo.helper
//
//  Created by Cyril Zakka on 10/12/24.
//

import Foundation

// MARK: - Helper

final class Helper: NSObject {
    let listener: NSXPCListener
    
    private var streamingProcess: Process?
    private var updateHandler: ((String) -> Void)?

    override init() {
        listener = NSXPCListener(machServiceName: HelperConstants.domain)
        super.init()
        listener.delegate = self
    }

    

}

// MARK: - HelperProtocol

extension Helper: HelperProtocol {
    func startStreamingPowerMetrics(updateHandler: @escaping (String) -> Void) {
            NSLog("startStreamingPowerMetrics called")
            self.updateHandler = updateHandler
            streamingProcess = ExecutionService.streamPowerMetrics { [weak self] output in
                NSLog("Received output in Helper")
                self?.updateHandler?(output)
            } 
        }
        
        func stopStreamingPowerMetrics() {
            NSLog("stopStreamingPowerMetrics called")
            streamingProcess?.terminate()
            streamingProcess = nil
            updateHandler = nil
        }
}

// MARK: - Run

extension Helper {

    func run() {
        // start listening on new connections
        listener.resume()

        // prevent the terminal application to exit
        RunLoop.current.run()
    }
}


// MARK: - NSXPCListenerDelegate

extension Helper: NSXPCListenerDelegate {

    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        do {
            try ConnectionIdentityService.checkConnectionIsValid(connection: newConnection)
        } catch {
            NSLog("Connection \(newConnection) has not been validated. \(error.localizedDescription)")
            return false
        }

        newConnection.exportedInterface = NSXPCInterface(with: HelperProtocol.self)
        newConnection.remoteObjectInterface = NSXPCInterface(with: RemoteApplicationProtocol.self)
        newConnection.exportedObject = self

        newConnection.resume()
        return true
    }
}
