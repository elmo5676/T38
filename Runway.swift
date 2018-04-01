//
//  Runways.swift
//  AirfieldsCD
//
//  Created by elmo on 3/31/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import Foundation

struct Runway: Codable {
    let type: String
    let features: [Feature]
}

struct Feature: Codable {
    let type: FeatureType
    let properties: Properties
    let geometry: Geometry
}

struct Geometry: Codable {
    let type: GeometryType
    let coordinates: [[[Double]]]
}

enum GeometryType: String, Codable {
    case polygon = "Polygon"
}

struct Properties: Codable {
    let objectid: Int
    let globalID, airportID: String
    let designator: String?
    let length, width: Int
    let dimUom: DimUom
    let compCode: CompCode
    let lightactv: Int?
    let lightintns: Lightintns?
    let akLow, akHigh, usLow, usHigh: Int
    let usArea, pacific: Int
    let shapeArea, shapeLength: Double
    
    enum CodingKeys: String, CodingKey {
        case objectid = "OBJECTID"
        case globalID = "GLOBAL_ID"
        case airportID = "AIRPORT_ID"
        case designator = "DESIGNATOR"
        case length = "LENGTH"
        case width = "WIDTH"
        case dimUom = "DIM_UOM"
        case compCode = "COMP_CODE"
        case lightactv = "LIGHTACTV"
        case lightintns = "LIGHTINTNS"
        case akLow = "AK_LOW"
        case akHigh = "AK_HIGH"
        case usLow = "US_LOW"
        case usHigh = "US_HIGH"
        case usArea = "US_AREA"
        case pacific = "PACIFIC"
        case shapeArea = "Shape__Area"
        case shapeLength = "Shape__Length"
    }
}

enum CompCode: String, Codable {
    case aspDirt = "ASP+DIRT"
    case aspGrs = "ASP+GRS"
    case aspGrvl = "ASP+GRVL"
    case aspTrtd = "ASP+TRTD"
    case asph = "ASPH"
    case comp = "COMP"
    case conc = "CONC"
    case concAsph = "CONC+ASPH"
    case concGrs = "CONC+GRS"
    case concGrvl = "CONC+GRVL"
    case concTrtd = "CONC+TRTD"
    case dirt = "DIRT"
    case grade = "GRADE"
    case grass = "GRASS"
    case grave = "GRAVE"
    case psp = "PSP"
    case roof = "ROOF"
    case sand = "SAND"
    case turfDirt = "TURF+DIRT"
    case turfGrvl = "TURF+GRVL"
    case unk = "UNK"
    case water = "WATER"
}

enum DimUom: String, Codable {
    case ft = "FT"
}

enum Lightintns: String, Codable {
    case empty = ""
    case lih = "LIH"
    case lil = "LIL"
    case lim = "LIM"
    case other = "OTHER"
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}






