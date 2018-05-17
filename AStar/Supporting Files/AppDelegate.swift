//
//  AppDelegate.swift
//  AStar
//
//  Created by Lin Knudsen on 6/7/17.
//  Copyright © 2017 Lin Knudsen. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func onMenuFindPathClick(_ sender: NSMenuItem) {
        if let pathScene = (NSApplication.shared.mainWindow?.contentViewController as? ViewController)?.scene {
            pathScene.pathfind()
        }
    }
    
    @IBAction func onMenuClearClick(_ sender: NSMenuItem) {
        if let pathScene = (NSApplication.shared.mainWindow?.contentViewController as? ViewController)?.scene {
            pathScene.clearWorld()
        }
    }
    
    @IBAction func onMenuSwitchBuildModeClick(_ sender: NSMenuItem) {
        if let pathScene = (NSApplication.shared.mainWindow?.contentViewController as? ViewController)?.scene {
            pathScene.switchBuildMode()
        }
    }
}
