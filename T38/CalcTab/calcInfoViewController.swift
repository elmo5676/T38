//
//  calcInfoViewController.swift
//  T38
//
//  Created by elmo on 3/26/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class calcInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()


        
    }

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if let fittedSize = instructionsStackView?.sizeThatFits(UILayoutFittingCompressedSize) {
//            preferredContentSize = CGSize(width: fittedSize.width + 20, height: fittedSize.height + 20)
//        }
    }
    
    private func updateUI(){
        if presentationController is UIPopoverPresentationController {
            dismissButtonOutlet?.isHidden = true
            view.backgroundColor = .clear
        } else {
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    
    @IBOutlet weak var windbuttonLabelOutlet: UILabel!
    @IBOutlet weak var dismissButtonOutlet: UIButton!
    @IBOutlet weak var instructionsStackView: UIStackView!
    @IBAction func dismissButton(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

}
