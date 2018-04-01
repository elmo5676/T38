
//
//  Created by elmo on 3/31/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation

struct Airport: Codable {
    let type: String
    let features: [Feature]
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case features = "features"
    }
    struct Feature: Codable {
        let type: FeatureType
        let properties: Properties
        let geometry: Geometry
        
        enum CodingKeys: String, CodingKey {
            case type = "type"
            case properties = "properties"
            case geometry = "geometry"
        }
    }
    struct Geometry: Codable {
        let type: GeometryType
        let coordinates: [Double]
        
        enum CodingKeys: String, CodingKey {
            case type = "type"
            case coordinates = "coordinates"
        }
    }
    
    enum GeometryType: String, Codable {
        case point = "Point"
    }
    struct Properties: Codable {
        let objectid: Int
        let globalID: String
        let ident: String?
        let name: String
        let latitude: String
        let longitude: String
        let elevation: Double
        let icaoID: String?
        let typeCode: TypeCode
        let servcity: String?
        let state: State?
        let country: Country
        let operstatus: Operstatus
        let privateuse: Int
        let iapexists: Int
        let dodhiflip: Int
        let far91: Int
        let far93: Int
        let milCode: MilCode
        let airanal: Airanal
        let usHigh: Int
        let usLow: Int
        let akHigh: Int
        let akLow: Int
        let usArea: Int
        let pacific: Int
        
        enum CodingKeys: String, CodingKey {
            case objectid = "OBJECTID"
            case globalID = "GLOBAL_ID"
            case ident = "IDENT"
            case name = "NAME"
            case latitude = "LATITUDE"
            case longitude = "LONGITUDE"
            case elevation = "ELEVATION"
            case icaoID = "ICAO_ID"
            case typeCode = "TYPE_CODE"
            case servcity = "SERVCITY"
            case state = "STATE"
            case country = "COUNTRY"
            case operstatus = "OPERSTATUS"
            case privateuse = "PRIVATEUSE"
            case iapexists = "IAPEXISTS"
            case dodhiflip = "DODHIFLIP"
            case far91 = "FAR91"
            case far93 = "FAR93"
            case milCode = "MIL_CODE"
            case airanal = "AIRANAL"
            case usHigh = "US_HIGH"
            case usLow = "US_LOW"
            case akHigh = "AK_HIGH"
            case akLow = "AK_LOW"
            case usArea = "US_AREA"
            case pacific = "PACIFIC"
        }
    }
    enum Airanal: String, Codable {
        case conditional = "CONDITIONAL"
        case noObjection = "NO OBJECTION"
        case notAnalyzed = "NOT ANALYZED"
    }
    
    enum Country: String, Codable {
        case bahamas = "BAHAMAS"
        case canada = "Canada"
        case countryBahamas = "Bahamas"
        case countryCanada = "CANADA"
        case fedStsMicronesia = "FED STS MICRONESIA"
        case guam = "GUAM"
        case kiribati = "Kiribati"
        case marshallIslands = "MARSHALL ISLANDS"
        case mexico = "Mexico"
        case midwayIslands = "MIDWAY ISLANDS"
        case northernMarianaIs = "NORTHERN MARIANA IS"
        case palau = "PALAU"
        case unitedStates = "UNITED STATES"
        case wakeIsland = "WAKE ISLAND"
    }
    
    enum MilCode: String, Codable {
        case all = "ALL"
        case civil = "CIVIL"
        case mil = "MIL"
    }
    
    enum Operstatus: String, Codable {
        case empty = ""
        case indefinite = "INDEFINITE"
        case operational = "OPERATIONAL"
    }
    
    enum State: String, Codable {
        case ak = "AK"
        case al = "AL"
        case ar = "AR"
        case az = "AZ"
        case ca = "CA"
        case co = "CO"
        case ct = "CT"
        case dc = "DC"
        case de = "DE"
        case fl = "FL"
        case ga = "GA"
        case hi = "HI"
        case ia = "IA"
        case id = "ID"
        case il = "IL"
        case ks = "KS"
        case ky = "KY"
        case la = "LA"
        case ma = "MA"
        case md = "MD"
        case me = "ME"
        case mi = "MI"
        case mn = "MN"
        case mo = "MO"
        case ms = "MS"
        case mt = "MT"
        case nc = "NC"
        case nd = "ND"
        case ne = "NE"
        case nh = "NH"
        case nj = "NJ"
        case nm = "NM"
        case novaScotia = "NOVA SCOTIA"
        case nv = "NV"
        case ny = "NY"
        case oh = "OH"
        case ok = "OK"
        case or = "OR"
        case pa = "PA"
        case ri = "RI"
        case sc = "SC"
        case sd = "SD"
        case stateIn = "IN"
        case tn = "TN"
        case tx = "TX"
        case ut = "UT"
        case va = "VA"
        case vt = "VT"
        case wa = "WA"
        case wi = "WI"
        case wv = "WV"
        case wy = "WY"
    }
    
    enum TypeCode: String, Codable {
        case ad = "AD"
        case hp = "HP"
        case sp = "SP"
    }
    
    enum FeatureType: String, Codable {
        case feature = "Feature"
    }
 
}











