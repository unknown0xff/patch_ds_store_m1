//
//  AppDelegate.swift
//  KProcessMonitor
//
//  Created by k on 2022/12/12.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    // 声明一个Popover
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        ProcessMonitor.Shared.run()

        if let button = statusItem.button {
            button.image = NSImage(named: "StatusIcon")
            button.action = #selector(togglePopover(_:))
        }
        popover.contentViewController = PopoverViewController.freshController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        return
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    // 控制Popover状态
      @objc func togglePopover(_ sender: AnyObject) {
          if popover.isShown {
              closePopover(sender)
          } else {
              showPopover(sender)
          }
      }
      // 显示Popover
      @objc func showPopover(_ sender: AnyObject) {
          if let button = statusItem.button {
              popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
          }
          
      }
      // 隐藏Popover
      @objc func closePopover(_ sender: AnyObject) {
          popover.performClose(sender)
      }

}

