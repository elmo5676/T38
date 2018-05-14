//
//  TOLDResultsViewController.swift
//  T38
//
//  Created by elmo on 4/29/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class TOLDResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("""
            HeadwindKey: \(HeadwindKey)
            CrosswindKey: \(CrosswindKey)
            MACSKeyKey: \(MACSKeyKey)
            MACSDistanceKey: \(MACSDistanceKey)
            DSKey: \(DSKey)
            RSEFKey: \(RSEFKey)
            SETOSKey: \(SETOSKey)
            SAEORKey: \(SAEORKey)
            GearDNSECGKey: \(GearDNSECGKey)
            GearUPSECGKey: \(GearUPSECGKey)
            CFLKey: \(CFLKey)
            NACSKey: \(NACSKey)
            RSBEOKey: \(RSBEOKey)
            RotationSpeedKey: \(RotationSpeedKey)
            TakeoffSpeedKey: \(TakeoffSpeedKey)
            TakeoffDistanceKey: \(TakeoffDistanceKey)
            CEFSKey: \(CEFSKey)
            EFSAEORKey: \(EFSAEORKey)
            EFGearDNSECGKey: \(EFGearDNSECGKey)
            EFGearUPSECGKey: \(EFGearUPSECGKey)
            givenEngFailAKey: \(givenEngFailAKey)
            """)
        print(resultsErrorArray)
        
        HeadwindKeyLabel.text = "HeadwindKey: \(HeadwindKey)"
        CrosswindKeyLabel.text = "CrosswindKey: \(CrosswindKey)"
        MACSKeyKeyLabel.text = "MACSKeyKey: \(MACSKeyKey)"
        MACSDistanceKeyLabel.text = "MACSDistanceKey: \(MACSDistanceKey)"
        DSKeyLabel.text = "DSKey: \(DSKey)"
        RSEFKeyLabel.text = "RSEFKey: \(RSEFKey)"
        SETOSKeyLabel.text = "SETOSKey: \(SETOSKey)"
        SAEORKeyLabel.text = "SAEORKey: \(SAEORKey)"
        GearDNSECGKeyLabel.text = "GearDNSECGKey: \(GearDNSECGKey)"
        GearUPSECGKeyLabel.text = "GearUPSECGKey: \(GearUPSECGKey)"
        CFLKeyLabel.text = "CFLKey: \(CFLKey)"
        NACSKeyLabel.text = "NACSKey: \(NACSKey)"
        RSBEOKeyLabel.text = "RSBEOKey: \(RSBEOKey)"
        RotationSpeedKeyLabel.text = "RotationSpeedKey: \(RotationSpeedKey)"
        TakeoffSpeedKeyLabel.text = "TakeoffSpeedKey: \(TakeoffSpeedKey)"
        TakeoffDistanceKeyLabel.text = "TakeoffDistanceKey: \(TakeoffDistanceKey)"
        CEFSKeyLabel.text = "CEFSKey: \(CEFSKey)"
        EFSAEORKeyLabel.text = "EFSAEORKey: \(EFSAEORKey)"
        EFGearDNSECGKeyLabel.text = "EFGearDNSECGKey: \(EFGearDNSECGKey)"
        EFGearUPSECGKeyLabel.text = "EFGearUPSECGKey: \(EFGearUPSECGKey)"
        givenEngFailAKeyLabel.text = "givenEngFailAKey: \(givenEngFailAKey)"
        //
        //    <#LabelName#>.text = "<#TextHere#>"
        //    <#LabelName#>.text = "<#TextHere#>"
        //    <#LabelName#>.text = "<#TextHere#>"
        //    <#LabelName#>.text = "<#TextHere#>"
        //    <#LabelName#>.text = "<#TextHere#>"
        //    <#LabelName#>.text = "<#TextHere#>"
        //    <#LabelName#>.text = "<#TextHere#>"
        
        


    }
    
    
    @IBOutlet weak var HeadwindKeyLabel: UILabel!
    @IBOutlet weak var CrosswindKeyLabel: UILabel!
    @IBOutlet weak var MACSKeyKeyLabel: UILabel!
    @IBOutlet weak var MACSDistanceKeyLabel: UILabel!
    @IBOutlet weak var DSKeyLabel: UILabel!
    @IBOutlet weak var RSEFKeyLabel: UILabel!
    @IBOutlet weak var SETOSKeyLabel: UILabel!
    @IBOutlet weak var SAEORKeyLabel: UILabel!
    @IBOutlet weak var GearDNSECGKeyLabel: UILabel!
    @IBOutlet weak var GearUPSECGKeyLabel: UILabel!
    @IBOutlet weak var CFLKeyLabel: UILabel!
    @IBOutlet weak var NACSKeyLabel: UILabel!
    @IBOutlet weak var RSBEOKeyLabel: UILabel!
    @IBOutlet weak var RotationSpeedKeyLabel: UILabel!
    @IBOutlet weak var TakeoffSpeedKeyLabel: UILabel!
    @IBOutlet weak var TakeoffDistanceKeyLabel: UILabel!
    @IBOutlet weak var CEFSKeyLabel: UILabel!
    @IBOutlet weak var EFSAEORKeyLabel: UILabel!
    @IBOutlet weak var EFGearDNSECGKeyLabel: UILabel!
    @IBOutlet weak var EFGearUPSECGKeyLabel: UILabel!
    @IBOutlet weak var givenEngFailAKeyLabel: UILabel!
    
    
    
    
   
    
    
    
    
    
    
    // MARK: RESULTS Variables
    // String
    var HeadwindKey = ""
    var CrosswindKey = ""
    var MACSKeyKey = ""
    var MACSDistanceKey = ""
    var DSKey = ""
    var RSEFKey = ""
    var SETOSKey = ""
    var SAEORKey = ""
    var GearDNSECGKey = ""
    var GearUPSECGKey = ""
    var CFLKey = ""
    var NACSKey = ""
    var RSBEOKey = ""
    var RotationSpeedKey = ""
    var TakeoffSpeedKey = ""
    var TakeoffDistanceKey = ""
    var CEFSKey = ""
    var EFSAEORKey = ""
    var EFGearDNSECGKey = ""
    var EFGearUPSECGKey = ""
    var givenEngFailAKey = ""
    // Error Array
    var resultsErrorArray = [String]()
    
    
    
    
}
