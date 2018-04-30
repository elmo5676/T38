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
        
        labelLabel.text = """
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
        """


    }

    @IBOutlet weak var labelLabel: UILabel!
    
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
