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
    
    let tc = UIScreen.main.traitCollection
    
    
    @IBOutlet weak var webViewTOLD: WKWebView!
    @IBAction func noteButton(_ sender: UIButton) {
    }
    
    func compact() -> URLRequest {
        if tc.horizontalSizeClass == .compact {
            let compactHtmlPath = Bundle.main.path(forResource: "indexCompact", ofType: "html")
            let url = URL(fileURLWithPath:  compactHtmlPath!)
            let request = URLRequest(url: url)
            return request
        } else {
            let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")
            let url = URL(fileURLWithPath:  htmlPath!)
            let request = URLRequest(url: url)
            return request
        }}
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        switch traitCollection.horizontalSizeClass {
        case .compact:
            webViewTOLD.reload()
        case .regular:
            webViewTOLD.reload()
        case .unspecified:
            webViewTOLD.reload()
        }
    }
    @IBOutlet weak var noteButtonOutlet: UIButton!
    override func viewDidLoad() {
        noteButtonOutlet.layer.cornerRadius = 20
        noteButtonOutlet.layer.borderWidth = 3
        noteButtonOutlet.layer.borderColor = #colorLiteral(red: 0.2771260142, green: 0.3437626958, blue: 0.4359292388, alpha: 1).cgColor

        super.viewDidLoad()
//        let url = URL(string: "https://t38.getatis.com")
//        let request = URLRequest(url: url!)
        webViewTOLD.load(compact())
        }
}


