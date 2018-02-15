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
        self.dismiss(animated: true, completion: nil)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.preferredContentSize.height = 30.0
//        self.preferredContentSize.width = 10.0
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //closeButtonOutlet.layer.cornerRadius = 3

    }

   
    

   

}
