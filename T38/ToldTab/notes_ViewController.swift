//
//  notes_ViewController.swift
//  T38
//
//  Created by elmo on 2/12/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class notes_ViewController: UIViewController {
    
    @IBOutlet weak var closeButtonOutlet: UIBarButtonItem!
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
