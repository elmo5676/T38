//
//  toldHTMLViewController.swift
//  T38
//
//  Created by elmo on 2/4/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit
import WebKit

class toldHTMLViewController: UIViewController {
    @IBOutlet weak var webViewTOLD: WKWebView!
    override func viewDidLoad() {
        
        
        let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")
        let url = URL(fileURLWithPath:  htmlPath!)
        let request = URLRequest(url: url)
        
        
        super.viewDidLoad()
//        let url = URL(string: "https://t38.getatis.com")
//        let request = URLRequest(url: url!)
        webViewTOLD.load(request)
        }
}

