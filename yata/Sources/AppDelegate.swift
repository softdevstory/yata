//
//  AppDelegate.swift
//  yata
//
//  Created by HS Song on 2017. 6. 12..
//  Copyright © 2017년 HS Song. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

//    let mainWindow = MainWindowController()
//    let aboutWindow = AboutWindowController()
//    let preferenceWindow = PreferenceWindowController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

//        NSApp.mainMenu = buildMenu()
//
//        mainWindow.showWindow(self)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

/*
// MARK: Menu
extension AppDelegate {

    func showAbout() {
        aboutWindow.showWindow(self)
    }
    
    func showPreference() {
        preferenceWindow.showWindow(self)
    }
    
    private func buildAppMenu() -> NSMenuItem {
        let appMenu = NSMenuItem()

        let subMenu = NSMenu()
        appMenu.submenu = subMenu
        
        subMenu.addItem(withTitle: "About YATA".localized, action: #selector(showAbout), keyEquivalent: "")
        subMenu.addItem(NSMenuItem.separator())

        subMenu.addItem(withTitle: "Preferences...".localized, action: #selector(showPreference), keyEquivalent: ",")
        subMenu.addItem(NSMenuItem.separator())
        
        let serviceMenu = NSMenu()
        NSApp.servicesMenu = serviceMenu
        
        subMenu.addItem(withTitle: "Services".localized, action: nil, keyEquivalent: "").submenu = serviceMenu
        subMenu.addItem(NSMenuItem.separator())

        subMenu.addItem(withTitle: "Hide YATA".localized, action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        subMenu.addItem(withTitle: "Hide Others".localized, action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h", keyEquivalentModifierMask: [.command, .option])

        subMenu.addItem(withTitle: "Show All".localized, action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        subMenu.addItem(NSMenuItem.separator())
        
        subMenu.addItem(withTitle: "Quit YATA".localized, action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        return appMenu
    }
    
    private func buildFileMenu() -> NSMenuItem {
        let fileMenu = NSMenuItem()
        
        let subMenu = NSMenu(title: "File".localized)
        fileMenu.submenu = subMenu
        
        return fileMenu
    }
    
    private func buildViewMenu() -> NSMenuItem {
        let viewMenu = NSMenuItem()
        
        let subMenu = NSMenu(title: "View".localized)
        viewMenu.submenu = subMenu
        
        subMenu.addItem(withTitle: "Hide Toolbar".localized, action: #selector(NSWindow.toggleToolbarShown(_:)), keyEquivalent: "t", keyEquivalentModifierMask: [.option, .command])

        subMenu.addItem(withTitle: "Customize Toolbar...".localized, action: #selector(NSWindow.runToolbarCustomizationPalette(_:)), keyEquivalent: "")
        
        subMenu.addItem(NSMenuItem.separator())
        
        subMenu.addItem(withTitle: "Hide Sidebar".localized, action: #selector(NSSplitViewController.toggleSidebar(_:)), keyEquivalent: "s", keyEquivalentModifierMask: [.command, .control])
        
        return viewMenu
    }
    
    private func buildHelpMenu() -> NSMenuItem {
        let helpMenu = NSMenuItem()

        let subMenu = NSMenu(title: "Help".localized)
        helpMenu.submenu = subMenu
        
        subMenu.addItem(withTitle: "YATA Help".localized, action: nil, keyEquivalent: "")
        
        return helpMenu
    }
    
    fileprivate func buildMenu() -> NSMenu {
        let menu = NSMenu()
        
        menu.addItem(buildAppMenu())
        menu.addItem(buildFileMenu())
        menu.addItem(buildViewMenu())
        menu.addItem(buildHelpMenu())
        
        return menu
    }
}
*/
