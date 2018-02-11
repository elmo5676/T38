//: Playground - noun: a place where people can play

import UIKit


var flameOutTable = ["FO_Alt_35":["-56":"0.77","-57":"0.79","-58":"0.80","-59":"0.81","-60":"0.83","-61":"0.85","-62":"0.86","-63":"0.88","-64":"0.89","-65":"0.90","-66":"0.92"], "FO_Alt_36": ["-56":"0.79","-57":"0.80","-58":"0.81","-59":"0.83","-60":"0.84","-61":"0.86","-62":"0.87","-63":"0.89","-64":"0.90","-65":"0.92","-66":"0.93"], "FO_Alt_37": ["-56":"0.80","-57":"0.81","-58":"0.83","-59":"0.84","-60":"0.86","-61":"0.87","-62":"0.89","-63":"0.90","-64":"0.92","-65":"0.93","-66":"0.95"], "FO_Alt_38": ["-56":"0.81","-57":"0.83","-58":"0.84","-59":"0.86","-60":"0.87","-61":"0.89","-62":"0.90","-63":"0.92","-64":"0.93","-65":"0.95","-66":"0.96"], "FO_Alt_39": ["-56":"0.83","-57":"0.84","-58":"0.86","-59":"0.87","-60":"0.89","-61":"0.90","-62":"0.91","-63":"0.93","-64":"0.94","-65":"0.96","-66":"0.98"],"FO_Alt_40" :["-56":"0.85","-57":"0.86","-58":"0.87","-59":"0.89","-60":"0.90","-61":"0.92","-62":"0.93","-63":"0.94","-64":"0.96","-65":"0.98","-66":"0.99"],"FO_Alt_41":["-56":"0.86","-57":"0.87","-58":"0.89","-59":"0.90","-60":"0.91","-61":"0.93","-62":"0.94","-63":"0.96","-64":"0.97","-65":"0.99","-66":"---"],"FO_Alt_42":["-56":"0.87","-57":"0.89","-58":"0.90","-59":"0.91","-60":"0.93","-61":"0.94","-62":"0.96","-63":"0.97","-64":"0.99","-65":"---","-66":"---"],"FO_Alt_43":["-56":"0.89","-57":"0.90","-58":"0.91","-59":"0.93","-60":"0.94","-61":"0.96","-62":"0.97","-63":"0.99","-64":"---","-65":"---","-66":"---"],"FO_Alt_44":["-56":"0.90","-57":"0.91","-58":"0.93","-59":"0.94","-60":"0.96","-61":"0.97","-62":"0.99","-63":"---","-64":"---","-65":"---","-66":"---"],"FO_Alt_45":["-56":"0.91","-57":"0.93","-58":"0.94","-59":"0.96","-60":"0.97","-61":"0.99","-62":"---","-63":"---","-64":"---","-65":"---","-66":"---"]
]

//A4-6
var standardDayFullyServicedFuel = 3790 //lbs
var groundTaxi = 18 //lbs/min
var fuelAllowanceTOandAccelerationToMil = 190 //lbs
var climbOutFromOtherThanInitialTO = 200 //lbs
//To correct for warmer days:
//(tempDeviation * restrictedClimb[ALT]?[6])+ restrictedClimb[ALT]?[5]
var tempDeviation = Float()


var restrictedClimb = [41:[-56.5,259,0.87,13.0,100,890,8,0.88,261,505,1380,23.0], 39:[-56.5,275,0.87,10.5,85,805,7,0.86,268,493,1385,23.1], 37:[-56.5,285,0.87,9.0,70,770,7,0.85,275,487,1450,24.2], 35:[-54.3,295,0.86,8.0,63,730,6,0.84,283,484,1510,25.2], 33:[-50.4,305,0.85,7.0,55,690,6,0.82,294,487,1530,25.5], 31:[-46.4,317,0.84,6.5,50,670,6,0.81,298,475,1600,26.7], 29:[-42.4,328,0.84,6.0,45,635,5,0.79,307,467,1630,27.2], 25:[-34.5,349,0.83,5.0,37,585,5,0.75,321,457,1730,28.8], 20:[-24.7,377,0.80,3.7,28,520,4,0.70,327,433,1890,31.5], 15:[-14.7,406,0.79,3.0,23,450,3,0.66,336,413,1980,33.0], 10:[-4.8,300,0.52,2.5,11,385,2,0.61,324,380,2040,34.0], 5:[5.1,300,0.50,2.0,5,250,2,0.46,280,300,2020,33.6]]

var machCruise = [41:[0.90,266,516,1455,24.3],39:[0.90,280,516,1470,24.5],37:[0.90,293,516,1560,26.0],35:[0.90,305,518,1720,28.7],33:[0.90,323,525,1780,29.7],31:[0.90,337,528,1950,32.5],29:[0.90,352,532,2080,34.7],25:[0.90,380,543,2260,37.7],20:[0.90,421,553,2840,47.3],15:[0.90,464,565,3320,55.3],10:[0.90,491,577,3750,62.5],5:[0.50,300,320,2200,36.7]]

var test = restrictedClimb[41]?[5]

var test2 = machCruise[41]






















