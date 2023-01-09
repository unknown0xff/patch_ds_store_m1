//
//  PopoverViewController.swift
//  KProcessMonitor
//
//  Created by k on 2022/12/12.
//

import Cocoa

class PopoverViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func exitAction(_ sender: Any) {
        exit(0)
    }
}

extension PopoverViewController {
    static func freshController() -> PopoverViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PopoverViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverViewController else {
            fatalError("Something Wrong with Main.storyboard")
        }
        return viewcontroller
    }
}

