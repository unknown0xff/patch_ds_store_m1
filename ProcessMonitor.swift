//* code by k

import Cocoa
import Foundation

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

func action() {
    DispatchQueue.global().async {
        if let file = Bundle.main.url(forResource: "patch", withExtension:"py") {
            _ = shell("python3", file.path)
        }
    }
}

class ProcessMonitor {
    static let Shared = ProcessMonitor()
    
    func run() {
        runOnce()
        
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didLaunchApplicationNotification,
            object: nil,
            queue: nil,
            using: notificationRecieved
        )
    }
    
    func runOnce() {
        action()
    }
    
    func notificationRecieved(noti: Notification) {
        if let proc = noti.userInfo as? [String: Any] {
            let name = proc["NSApplicationName"] as! String
            let pid = proc["NSApplicationProcessIdentifier"] as! Int

            if name == "Finder" {
                print("Finder:", name, pid)
                action()
            }
        }
    }
}
