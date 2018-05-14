// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

struct Weather: Codable {
    let metars: Metars
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
    //let qualityControlFlags: QualityControlFlags
    //let skyCondition: SkyCondition
    //let flightCategory, metarType, elevationM: String
    
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
        //case qualityControlFlags = "quality_control_flags"
        //case skyCondition = "sky_condition"
        //case flightCategory = "flight_category"
        //case metarType = "metar_type"
        //case elevationM = "elevation_m"
    }
}

struct QualityControlFlags: Codable {
    let autoStation: String
    
    enum CodingKeys: String, CodingKey {
        case autoStation = "auto_station"
    }
}

struct SkyCondition: Codable {
    let skyCover, cloudBaseFtAgl: String
    
    enum CodingKeys: String, CodingKey {
        case skyCover = "@sky_cover"
        case cloudBaseFtAgl = "@cloud_base_ft_agl"
    }
}
