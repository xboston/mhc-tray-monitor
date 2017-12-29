//
//  AppDelegate.swift
//  RaiMoon
//
//  Created by Daniel Tatom on 12/28/17.
//  Copyright © 2017 Daniel Tatom. All rights reserved.
//

import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    
    var item : NSStatusItem? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        item?.title = "Fetching price..."
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: ""))
        item?.menu = menu
        
        fetchPrice()
        
        Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(fetchPrice), userInfo: nil, repeats: true)
    }

    @objc func fetchPrice() {
        print("Fetching price...")
        
        Alamofire.request("https://api.coinmarketcap.com/v1/ticker/raiblocks/").responseJSON { response in
            if let data = response.result.value{
                if  (data as? [[String : AnyObject]]) != nil{
                    if let dictionaryArray = data as? Array<Dictionary<String, AnyObject?>> {
                        let price = dictionaryArray[0]["price_usd"] as? String
                        
                        self.item?.title = "XRB $\(price ?? "???")"
                    }
                }
            } else {
                let error = (response.result.value  as? [[String : AnyObject]])
                print(error as Any)
            }
        }
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
