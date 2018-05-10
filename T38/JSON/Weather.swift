//// To parse the JSON, add this file to your project and do:
////
////   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)
//
//import Foundation
//
//struct Weather: Codable {
////    let xml: XML
//    let metars: Metars
//
//    enum CodingKeys: String, CodingKey {
////        case xml = "?xml"
//        case metars = "metars"
//    }
//}
//
//struct Metars: Codable {
//    let metar: Metar
//
//    enum CodingKeys: String, CodingKey {
//        case metar = "METAR"
//    }
//}
//
//struct Metar: Codable {
//    let rawText: String
//    let stationID: String
//    let observationTime: String
//    let latitude: Double
//    let longitude: Double
//    let tempC: Double
//    let dewpointC: Double
//    let windDirDegrees: Double
//    let windSpeedKt: Double
//    let windGustKt: Double
//    let visibilityStatuteMi: Double
//    let altimInHg: Double
//    let seaLevelPressureMB: Double
//    let qualityControlFlags: String
//    let skyCondition: [SkyCondition]
//    let flightCategory: String
//    let metarType: String
//    let elevationM: Double
//
//    enum CodingKeys: String, CodingKey {
//        case rawText = "raw_text"
//        case stationID = "station_id"
//        case observationTime = "observation_time"
//        case latitude, longitude
//        case tempC = "temp_c"
//        case dewpointC = "dewpoint_c"
//        case windDirDegrees = "wind_dir_degrees"
//        case windSpeedKt = "wind_speed_kt"
//        case windGustKt = "wind_gust_kt"
//        case visibilityStatuteMi = "visibility_statute_mi"
//        case altimInHg = "altim_in_hg"
//        case seaLevelPressureMB = "sea_level_pressure_mb"
//        case qualityControlFlags = "quality_control_flags"
//        case skyCondition = "sky_condition"
//        case flightCategory = "flight_category"
//        case metarType = "metar_type"
//        case elevationM = "elevation_m"
//    }
//}
//
//struct SkyCondition: Codable {
//    let skyCover, cloudBaseFtAgl: String
//
//    enum CodingKeys: String, CodingKey {
//        case skyCover = "@sky_cover"
//        case cloudBaseFtAgl = "@cloud_base_ft_agl"
//    }
//}
//
//struct XML: Codable {
//    let version, encoding: String
//
//    enum CodingKeys: String, CodingKey {
//        case version = "@version"
//        case encoding = "@encoding"
//    }
//}


// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

struct Weather: Codable {
    let xml: XML
    let metars: Metars
    
    enum CodingKeys: String, CodingKey {
        case xml = "?xml"
        case metars
    }
}

struct Metars: Codable {
    let metar: Metar
    
    enum CodingKeys: String, CodingKey {
        case metar = "METAR"
    }
}

struct Metar: Codable {
    let rawText, stationID, observationTime, latitude: String
    let longitude, tempC, dewpointC, windDirDegrees: String
    let windSpeedKt, visibilityStatuteMi, altimInHg, seaLevelPressureMB: String
    let qualityControlFlags: QualityControlFlags
    let skyCondition: SkyCondition
    let flightCategory, threeHrPressureTendencyMB, metarType, elevationM: String
    
    enum CodingKeys: String, CodingKey {
        case rawText = "raw_text"
        case stationID = "station_id"
        case observationTime = "observation_time"
        case latitude, longitude
        case tempC = "temp_c"
        case dewpointC = "dewpoint_c"
        case windDirDegrees = "wind_dir_degrees"
        case windSpeedKt = "wind_speed_kt"
        case visibilityStatuteMi = "visibility_statute_mi"
        case altimInHg = "altim_in_hg"
        case seaLevelPressureMB = "sea_level_pressure_mb"
        case qualityControlFlags = "quality_control_flags"
        case skyCondition = "sky_condition"
        case flightCategory = "flight_category"
        case threeHrPressureTendencyMB = "three_hr_pressure_tendency_mb"
        case metarType = "metar_type"
        case elevationM = "elevation_m"
    }
}

struct QualityControlFlags: Codable {
    let auto, autoStation, maintenanceIndicatorOn: String
    
    enum CodingKeys: String, CodingKey {
        case auto
        case autoStation = "auto_station"
        case maintenanceIndicatorOn = "maintenance_indicator_on"
    }
}

struct SkyCondition: Codable {
    let skyCover: String
    
    enum CodingKeys: String, CodingKey {
        case skyCover = "@sky_cover"
    }
}

struct XML: Codable {
    let version, encoding: String
    
    enum CodingKeys: String, CodingKey {
        case version = "@version"
        case encoding = "@encoding"
    }
}

