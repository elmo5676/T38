/******************************************************************************
* NCI Information Systems, Inc.                                               *
*******************************************************************************
* Module: T38TOLDConversions.js                                               *
* Date:   2013-11-26                                                          *
* Author: Jeff Peters                                                         *
* For:    United States Air Force, 394th CTS                                  *
*******************************************************************************
* DESCRIPTION                                                                 *
*******************************************************************************
* This module consists of logic converted from the Excel spreadsheet named    *
* TOLD_Calc_V4 012Sept13.xls.                                                 *
*******************************************************************************
* HISTORY                                                                     *
*******************************************************************************
* 2013-11-26 - finished initial code conversion and debugging                 *
* 2013-12-12 - Debugged KCAS2M(kc, alt)                                       *
*                                                                             *
*******************************************************************************
*/


var constTsl = 15;              // C
var constPsl = 2116.2;          // lbf/ft^2
var constRhosl = 0.0023772;     // slug/ft^3
var constGamma = 1.4;           // Ratio of specific heats
var constR = 3089.8136;         // Gas Constant ft^2/(s^2*K)
var constRR = 1716.546755;      // Gas Constant ft^2/(s^2*R)
var constAlapse = -0.00356616;  // R/ft
var constG = 32.1751969;        // ft/s^2

function Palt(alt) {  // Pressure [lb/ft^2]
  return delta(alt) * constPsl;
}

function rho(alt, TC) {  //Density [slug/ft^3]
  if (alt > 65617) {
    return "error altitude > 65617";    
  }
  var p = Palt(alt);
  var t = TC2K(TC);
  var r = p / (constR * t);
  return r;
}

function theta(alt) {    //Temperature Ratio
  var T = TC2R(constTsl);
  if (alt < 36089) {
    th = 1 * 1 + constAlapse * alt / T;
  }
  if (alt >= 36089) {
    th = 1 * 1 + constAlapse * 36089 / T;
  }
  if (alt > 65617) {
    th = "error altitude > 65617";
  }
  return th;
}


function delta(alt) {   // Pressure Ratio
  if (alt < 36089) {
    d = Math.pow(theta(alt),(-constG / (constAlapse * constRR)));
  }
  if (alt >= 36089) {
    d = 0.2234 * Math.exp(-(alt - 36089) / 20806.7);
  }
  if (alt > 65617) {
    d = "error altitude > 65617";
  }
  return d;
}

function TF2C(TF) {
  var t = (TF - 32) / 1.8;
  return t;
}

function TC2K(TC) {
  var t = TC * 1.0 + 273.15;
  return t;
}

function TC2R(TC) {
  var t = TC * 1.8 + 32 + 459.67;
  return t;
}


function SS(TC) {
  var t = TC2K(TC);
  var ss = Math.pow(constGamma * constR * t, 0.5);
  return ss;
}

function KT2fps(Vkt) {
  var k = 1.687809857 * Vkt;
  return k;
}


function fps2KT(Vfps) {
  var v = Vfps / 1.687809857;
  return v;
}

function KCAS2M(kc, alt) {
  var Va1 = SS(15);
  var Va = fps2KT(Va1);
  var del = delta(alt);
  // The following statements reduce this VBA expression's complexity: a = ((1 + ((gamma - 1) / 2) * ((KCAS / Va) ^ 2)) ^ (gamma / (gamma - 1)) - 1) / del
  var p = constGamma - 1;
  var q = constGamma/p;
  var r = p/2;
  var s = Math.pow(kc/Va,2);
  var t = 1 * 1 + r * s;
  // So the reduced complexity version is on the next line
  var a = (Math.pow(t,q) - 1)/del;
  
  var b = ((Math.pow(a + 1 * 1,p/constGamma) - 1) * 2) / p;
  var k = Math.pow(b,0.5);
  return k;
}
  
function KCAS2KTAS(kc, alt, TC) {
  var M = KCAS2M(kc, alt);
  var Va1 = SS(TC);
  var Va = fps2KT(Va1);
  var k = M * Va;
  return k;
}
