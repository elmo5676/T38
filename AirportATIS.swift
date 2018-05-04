//// To parse the JSON, add this file to your project and do:
////
////   let airport = try? JSONDecoder().decode(Airport.self, from: jsonData)
//
//import Foundation
//
//typealias Airport = [AirportElement]
//
//struct AirportElement: Codable {
//    let objectID: Int
//    let airportID: String
//    let ident: String?
//    let lat, lon: String
//    let elevation: Double
//    let icao, city: String?
//    let state: State?
//    let runways: [Runway]
//    
//    enum CodingKeys: String, CodingKey {
//        case objectID = "ObjectID"
//        case airportID = "AirportID"
//        case ident = "Ident"
//        case lat = "Lat"
//        case lon = "Lon"
//        case elevation = "Elevation"
//        case icao = "ICAO"
//        case city = "City"
//        case state = "State"
//        case runways = "Runways"
//    }
//}
//
//struct Runway: Codable {
//    let airportID, designator: String
//    let length, width: Int
//    let coordinates: [String]
//    
//    enum CodingKeys: String, CodingKey {
//        case airportID = "AirportID"
//        case designator = "Designator"
//        case length = "Length"
//        case width = "Width"
//        case coordinates = "Coordinates"
//    }
//}
//
//enum State: String, Codable {
//    case ak = "AK"
//    case al = "AL"
//    case ar = "AR"
//    case az = "AZ"
//    case ca = "CA"
//    case co = "CO"
//    case ct = "CT"
//    case dc = "DC"
//    case de = "DE"
//    case fl = "FL"
//    case ga = "GA"
//    case hi = "HI"
//    case ia = "IA"
//    case id = "ID"
//    case il = "IL"
//    case ks = "KS"
//    case ky = "KY"
//    case la = "LA"
//    case ma = "MA"
//    case md = "MD"
//    case me = "ME"
//    case mi = "MI"
//    case mn = "MN"
//    case mo = "MO"
//    case ms = "MS"
//    case mt = "MT"
//    case nc = "NC"
//    case nd = "ND"
//    case ne = "NE"
//    case nh = "NH"
//    case nj = "NJ"
//    case nm = "NM"
//    case nv = "NV"
//    case ny = "NY"
//    case oh = "OH"
//    case ok = "OK"
//    case or = "OR"
//    case pa = "PA"
//    case ri = "RI"
//    case sc = "SC"
//    case sd = "SD"
//    case stateIN = "IN"
//    case tn = "TN"
//    case tx = "TX"
//    case ut = "UT"
//    case va = "VA"
//    case vt = "VT"
//    case wa = "WA"
//    case wi = "WI"
//    case wv = "WV"
//    case wy = "WY"
//}
