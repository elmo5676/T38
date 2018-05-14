//
//  NearestTableViewCell.swift
//  T38
//
//  Created by elmo on 5/12/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class NearestTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet var icaoLabel: UILabel!
    @IBOutlet var rangeLabel: UILabel!
    @IBOutlet var bearingLabel: UILabel!
    @IBOutlet var directToButtonOutlet: UIButton!
    @IBAction func directToButton(_ sender: UIButton) {
        let ICAO = icaoLabel.text
//        presentingViewController?.dismiss(animated: true, completion: nil)
        var urlString = URLComponents(string: "foreflightmobile://maps/search?")!
        urlString.query = "q=D \(String(describing: ICAO!))"
        let url = urlString.url!
        UIApplication.shared.open(url , options: [:], completionHandler: nil)
        sender.backgroundColor = #colorLiteral(red: 0.6157805324, green: 0.6158866882, blue: 0.6157665849, alpha: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.2549019608, blue: 0.3098039216, alpha: 1)
//            sender.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        }

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
