// To parse the JSON, add this file to your project and do:
//
//   let airfields = try? JSONDecoder().decode(Airfields.self, from: jsonData)

import Foundation

typealias Airfields = [Airfield]
//typealias Communications = [Communication]
//typealias CommFreqs = [CommFreq]
//typealias Navaids = [Navaid]
//typealias Runways = [Runway]

struct Airfield: Codable {
    let id: Int
    let icao: String
    let faa: String
    let country: String
    let name: String
    let state: String
    let elevation: Double
    let lat: Double
    let lon: Double
    let mgrs: String
    let timeConversion: String
    let communications: [Communication]
    let navaids: [Navaid]
    let runways: [Runway]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case icao = "ICAO"
        case faa = "FAA"
        case country = "Country"
        case name = "Name"
        case state = "State"
        case elevation = "Elevation"
        case lat = "Lat"
        case lon = "Lon"
        case mgrs = "MGRS"
        case timeConversion = "Time_Conversion"
        case communications = "Communications"
        case navaids = "Navaids"
        case runways = "Runways"
    }
}

struct Communication: Codable {
    let id: Int
    let name: String
    let freqs: [Freq]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "Name"
        case freqs = "Freqs"
    }
}

struct Freq: Codable {
    let id: Int
    let freq: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case freq = "Freq"
    }
}

struct Navaid: Codable {
    let id: Int
    let name: String
    let ident: String
    let type: Int
    let lat: Double
    let lon: Double
    let frequency: Double
    let channel: Int
    let tacanDMEMode: String
    let course: Int
    let distance: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "Name"
        case ident = "Ident"
        case type = "Type"
        case lat = "Lat"
        case lon = "Lon"
        case frequency = "Frequency"
        case channel = "Channel"
        case tacanDMEMode = "Tacan_DME_Mode"
        case course = "Course"
        case distance = "Distance"
    }
}

struct Runway: Codable {
    let id: Int
    let lowID: String
    let highID: String
    let length: Double
    let width: Double
    let surfaceType: Int? //SurfaceType
    let runwayCondition: Int? //SurfaceType
    let magHdgHi: Double
    let magHdgLow: Double
    let trueHdgHi: Double
    let trueHdgLow: Double
    let coordLatHi: Double
    let coordLatLo: Double
    let coordLonHi: Double
    let coordLonLo: Double
    let elevHi: Double
    let elevLow: Double
    let slopeHi: Double
    let slopeLow: Double
    let tdzeHi: Double
    let tdzeLow: Double
    let overrunHiLength: Double
    let overrunLowLength: Double
    let overrunHiType: Int? //SurfaceType
    let overrunLowType: Int? //SurfaceType
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case lowID = "lowID"
        case highID = "highID"
        case length = "Length"
        case width = "Width"
        case surfaceType = "SurfaceType"
        case runwayCondition = "RunwayCondition"
        case magHdgHi = "MagHdgHi"
        case magHdgLow = "MagHdgLow"
        case trueHdgHi = "TrueHdgHi"
        case trueHdgLow = "TrueHdgLow"
        case coordLatHi = "Coord_Lat_Hi"
        case coordLatLo = "Coord_Lat_Lo"
        case coordLonHi = "Coord_Lon_Hi"
        case coordLonLo = "Coord_Lon_Lo"
        case elevHi = "Elev_Hi"
        case elevLow = "Elev_Low"
        case slopeHi = "Slope_Hi"
        case slopeLow = "Slope_Low"
        case tdzeHi = "TDZE_Hi"
        case tdzeLow = "TDZE_Low"
        case overrunHiLength = "Overrun_Hi_Length"
        case overrunLowLength = "Overrun_Low_Length"
        case overrunHiType = "Overrun_Hi_Type"
        case overrunLowType = "Overrun_Low_Type"
    }
}


























//struct Airfield: Codable {
//    let communications: [Communication]
//    let navaids: [Navaid]
//    let runways: [Runway]
//    let id: Int
//    let icao: String
//    let faa: String
//    let country: Country
//    let name: String
//    let state: State
//    let elevation: Double
//    let lat: Double
//    let lon: Double
//    let mgrs: String
//    let timeConversion: TimeConversion
//
//    enum CodingKeys: String, CodingKey {
//        case communications = "Communications"
//        case navaids = "Navaids"
//        case runways = "Runways"
//        case id = "id"
//        case icao = "ICAO"
//        case faa = "FAA"
//        case country = "Country"
//        case name = "Name"
//        case state = "State"
//        case elevation = "Elevation"
//        case lat = "Lat"
//        case lon = "Lon"
//        case mgrs = "MGRS"
//        case timeConversion = "Time_Conversion"
//    }
//}
//
//struct Communication: Codable {
//    let freqs: [CommFreq]
//    let id: Int
//    let name: String
//
//    enum CodingKeys: String, CodingKey {
//        case freqs = "Freqs"
//        case id = "id"
//        case name = "Name"
//    }
//}
//
//struct CommFreq: Codable {
//    let id: Int
//    let freq: Double
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case freq = "Freq"
//    }
//}
//
//enum Country: String, Codable {
//    case unitedStates = "United States"
//}
//
//struct Navaid: Codable {
//    let id: Int
//    let name: String
//    let ident: String
//    let type: Int
//    let lat: Double
//    let lon: Double
//    let frequency: Double
//    let channel: Int
//    let tacanDMEMode: TacanDMEMode
//    let course: Int
//    let distance: Double
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case name = "Name"
//        case ident = "Ident"
//        case type = "Type"
//        case lat = "Lat"
//        case lon = "Lon"
//        case frequency = "Frequency"
//        case channel = "Channel"
//        case tacanDMEMode = "Tacan_DME_Mode"
//        case course = "Course"
//        case distance = "Distance"
//    }
//}
//
//enum TacanDMEMode: String, Codable {
//    case empty = ""
//    case x = "X"
//    case y = "Y"
//}
//
//struct Runway: Codable {
//    let id: Int
//    let lowID: LowID
//    let highID: HighID
//    let length: Double
//    let width: Double
//    let surfaceType: Int
//    let runwayCondition: Int
//    let magHdgHi: Double
//    let magHdgLow: Double
//    let trueHdgHi: Double
//    let trueHdgLow: Double
//    let coordLatHi: Double
//    let coordLatLo: Double
//    let coordLonHi: Double
//    let coordLonLo: Double
//    let elevHi: Double
//    let elevLow: Double
//    let slopeHi: Double
//    let slopeLow: Double
//    let tdzeHi: Double
//    let tdzeLow: Double
//    let overrunHiLength: Double
//    let overrunLowLength: Double
//    let overrunHiType: Int
//    let overrunLowType: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case lowID = "lowID"
//        case highID = "highID"
//        case length = "Length"
//        case width = "Width"
//        case surfaceType = "SurfaceType"
//        case runwayCondition = "RunwayCondition"
//        case magHdgHi = "MagHdgHi"
//        case magHdgLow = "MagHdgLow"
//        case trueHdgHi = "TrueHdgHi"
//        case trueHdgLow = "TrueHdgLow"
//        case coordLatHi = "Coord_Lat_Hi"
//        case coordLatLo = "Coord_Lat_Lo"
//        case coordLonHi = "Coord_Lon_Hi"
//        case coordLonLo = "Coord_Lon_Lo"
//        case elevHi = "Elev_Hi"
//        case elevLow = "Elev_Low"
//        case slopeHi = "Slope_Hi"
//        case slopeLow = "Slope_Low"
//        case tdzeHi = "TDZE_Hi"
//        case tdzeLow = "TDZE_Low"
//        case overrunHiLength = "Overrun_Hi_Length"
//        case overrunLowLength = "Overrun_Low_Length"
//        case overrunHiType = "Overrun_Hi_Type"
//        case overrunLowType = "Overrun_Low_Type"
//    }
//}
//
//enum HighID: String, Codable {
//    case the19 = "19"
//    case the19C = "19C"
//    case the19L = "19L"
//    case the19R = "19R"
//    case the20 = "20"
//    case the20C = "20C"
//    case the20L = "20L"
//    case the20R = "20R"
//    case the21 = "21"
//    case the21L = "21L"
//    case the21R = "21R"
//    case the22 = "22"
//    case the22L = "22L"
//    case the22R = "22R"
//    case the22S = "22S"
//    case the23 = "23"
//    case the23L = "23L"
//    case the23R = "23R"
//    case the24 = "24"
//    case the24L = "24L"
//    case the24R = "24R"
//    case the25 = "25"
//    case the25L = "25L"
//    case the25R = "25R"
//    case the25S = "25S"
//    case the26 = "26"
//    case the26L = "26L"
//    case the26R = "26R"
//    case the27 = "27"
//    case the27C = "27C"
//    case the27L = "27L"
//    case the27R = "27R"
//    case the28 = "28"
//    case the28C = "28C"
//    case the28L = "28L"
//    case the28R = "28R"
//    case the29 = "29"
//    case the29L = "29L"
//    case the29R = "29R"
//    case the30 = "30"
//    case the30C = "30C"
//    case the30L = "30L"
//    case the30R = "30R"
//    case the31 = "31"
//    case the31C = "31C"
//    case the31L = "31L"
//    case the31R = "31R"
//    case the32 = "32"
//    case the32L = "32L"
//    case the32R = "32R"
//    case the33 = "33"
//    case the33C = "33C"
//    case the33L = "33L"
//    case the33R = "33R"
//    case the34 = "34"
//    case the34C = "34C"
//    case the34L = "34L"
//    case the34R = "34R"
//    case the34S = "34S"
//    case the35 = "35"
//    case the35C = "35C"
//    case the35L = "35L"
//    case the35R = "35R"
//    case the36 = "36"
//    case the36C = "36C"
//    case the36L = "36L"
//    case the36R = "36R"
//}
//
//enum LowID: String, Codable {
//    case the01 = "01"
//    case the01C = "01C"
//    case the01L = "01L"
//    case the01R = "01R"
//    case the02 = "02"
//    case the02C = "02C"
//    case the02L = "02L"
//    case the02R = "02R"
//    case the03 = "03"
//    case the03L = "03L"
//    case the03R = "03R"
//    case the04 = "04"
//    case the04L = "04L"
//    case the04R = "04R"
//    case the04S = "04S"
//    case the05 = "05"
//    case the05L = "05L"
//    case the05R = "05R"
//    case the06 = "06"
//    case the06L = "06L"
//    case the06R = "06R"
//    case the07 = "07"
//    case the07L = "07L"
//    case the07R = "07R"
//    case the07S = "07S"
//    case the08 = "08"
//    case the08L = "08L"
//    case the08R = "08R"
//    case the09 = "09"
//    case the09C = "09C"
//    case the09L = "09L"
//    case the09R = "09R"
//    case the10 = "10"
//    case the10C = "10C"
//    case the10L = "10L"
//    case the10R = "10R"
//    case the11 = "11"
//    case the11L = "11L"
//    case the11R = "11R"
//    case the12 = "12"
//    case the12C = "12C"
//    case the12L = "12L"
//    case the12R = "12R"
//    case the13 = "13"
//    case the13C = "13C"
//    case the13L = "13L"
//    case the13R = "13R"
//    case the14 = "14"
//    case the14L = "14L"
//    case the14R = "14R"
//    case the15 = "15"
//    case the15C = "15C"
//    case the15L = "15L"
//    case the15R = "15R"
//    case the16 = "16"
//    case the16C = "16C"
//    case the16L = "16L"
//    case the16R = "16R"
//    case the16S = "16S"
//    case the17 = "17"
//    case the17C = "17C"
//    case the17L = "17L"
//    case the17R = "17R"
//    case the18 = "18"
//    case the18C = "18C"
//    case the18L = "18L"
//    case the18R = "18R"
//}
//
//enum State: String, Codable {
//    case alabama = "Alabama"
//    case alaska = "Alaska"
//    case arizona = "Arizona"
//    case arkansas = "Arkansas"
//    case california = "California"
//    case colorado = "Colorado"
//    case connecticut = "Connecticut"
//    case delaware = "Delaware"
//    case districtOfColumbia = "District of Columbia"
//    case florida = "Florida"
//    case georgia = "Georgia"
//    case hawaii = "Hawaii"
//    case idaho = "Idaho"
//    case illinois = "Illinois"
//    case indiana = "Indiana"
//    case iowa = "Iowa"
//    case kansas = "Kansas"
//    case kentucky = "Kentucky"
//    case louisiana = "Louisiana"
//    case maine = "Maine"
//    case maryland = "Maryland"
//    case massachusetts = "Massachusetts"
//    case michigan = "Michigan"
//    case minnesota = "Minnesota"
//    case mississippi = "Mississippi"
//    case missouri = "Missouri"
//    case montana = "Montana"
//    case nebraska = "Nebraska"
//    case nevada = "Nevada"
//    case newHampshire = "New Hampshire"
//    case newJersey = "New Jersey"
//    case newMexico = "New Mexico"
//    case newYork = "New York"
//    case northCarolina = "North Carolina"
//    case northDakota = "North Dakota"
//    case ohio = "Ohio"
//    case oklahoma = "Oklahoma"
//    case oregon = "Oregon"
//    case pennsylvania = "Pennsylvania"
//    case rhodeIsland = "Rhode Island"
//    case southCarolina = "South Carolina"
//    case southDakota = "South Dakota"
//    case tennessee = "Tennessee"
//    case texas = "Texas"
//    case utah = "Utah"
//    case vermont = "Vermont"
//    case virginia = "Virginia"
//    case washington = "Washington"
//    case westVirginia = "West Virginia"
//    case wisconsin = "Wisconsin"
//    case wyoming = "Wyoming"
//}
//
//enum TimeConversion: String, Codable {
//    case empty = ""
//    case utc10 = "UTC-10"
//    case utc54Dt = "UTC-5(-4DT)"
//    case utc65Dt = "UTC-6(-5DT)"
//    case utc7 = "UTC-7"
//    case utc76Dt = "UTC-7(-6DT)"
//    case utc87Dt = "UTC-8(-7DT)"
//}






