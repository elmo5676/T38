/******************************************************************************
* NCI Information Systems, Inc.                                               *
*******************************************************************************
* Module: T38TOLDresults.js                                                   *
* Date:   2013-11-26                                                          *
* Author: Jeff Peters                                                         *
* For:    United States Air Force, 394th CTS                                  *
*******************************************************************************
* DESCRIPTION                                                                 *
*******************************************************************************
* This module consists of logic originally converted from the Excel file named*
* TOLD_Calc_V4 012Sept13.xls.                                                 *
*******************************************************************************
* HISTORY                                                                     *
*******************************************************************************
* 2013-11-26 - finished initial code conversion and debugging                 *
* 2013-11-28 - Fixed SECG calculation 'NaN' bug                               *
* 2013-12-06 - Changed 'SEROC' to 'SECG'                                      *
* 2013-12-06 - Debugged DS calculation and all interpolation calls            *
* 2013-12-09 - Added handling for podMounted                                  *
* 2013-12-12 - Finished debugging SECG calculations                           *
* 2013-12-19 - Added subtraction of fuel burned during taxi (360lbs.)         *
* 2013-12-22 - Removed rounding from calcHeadwind(); added rounding to        *
*              Headwind variable just before output to page.                  *
* 2013-12-27 - Additional debugging on DS, SETOS, and SECG calcs.             *
* 2013-12-28 - Debugged MACS calculation                                      *
* 2014-01-16 - Fixed bug with wind calculation (ln 2007)                      *
* 2014-03-24 - Moved pod weight addition to front-end                         *
* 2014-04-03 - Removed subtraction of fuel burned (changes in input form)     *
* 2014-05-08 - Removed restriction for podMounted = 0 (WSSPin on spreadsheet) *
*              Fixed DS bug for tailwind conditions (DSwindCorrect())         *
* 2014-05-12 - Streamlined error messages                                     *
* 2014-05-13 - Fixed temp vs. tempK bug in SECG interp call                   *
*              Fixed temp-related bug in DS lookups                           *
* 2014-05-15 - Removed all replace-data-with-asterisk error handlers except   *
*              SETO Not Possible                                              *
*              Disabled replace-data-with-asterisk; kept error messages as    *
*                specified by Capt. Bressett.
*******************************************************************************
*/
var gErrMsgs = [];

// Following allows reference to a URL var with syntax:
//  var byName = $.getUrlVar('name');
// or all URL vars as jquery object:
//  var allVars = $.getUrlVars();
$.extend({
  getUrlVars: function(){
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
      hash = hashes[i].split('=');
      vars.push(hash[0]);
      vars[hash[0]] = hash[1];
    }
    return vars;
  },
  getUrlVar: function(name){
    return $.getUrlVars()[name];
  }
});

// General function to select upper and lower bounds for a specified value and array of bins
// Bins must be an array with descending values
function pickBounds(v,bins) {
  var bounds = [];
  for (i=0;i < bins.length; i++){
    if (v < bins[i] && v >= bins[i+1]) {
      bounds[0] = bins[i+1];
      bounds[1] = bins[i];
      break;
    }
  }
  if (v == bins[0]) {
    bounds[0] = bins[1];
    bounds[1] = bins[0];
  }
  return bounds;
}

// General function to perform linear interpolation
function linterp(lv,hv,lf,hf,fc) {
  var interpval = (lv * 1.0) + ((hv-lv) / (hf-lf)) * (fc-lf);
  return interpval;
}

function CFLwind(c, w) {
  if (w > 0) {
    var Wn2 = 13006;
    var Wn1 = 10999;
    var Wnb = 0.4579 * Math.pow(w,2) - 88.973 * w + 13006;
    var Wna = 0.4372 * Math.pow(w,2) - 101.38 * w + 10999;
    if (c < 6999) {
      Wn2 = 6999;
      Wn1 = 5001;
      Wnb = 0.146 * Math.pow(w,2) - 62.008 * w + 6998.8;
      Wna = 0.1782 * Math.pow(w,2) - 52.545 * w + 5000.6;
    } else if (c < 9001) {
      Wn2 = 9001;
      Wn1 = 6999;
      Wnb = 0.2736 * Math.pow(w,2) - 84.668 * w + 9000.9;
      Wna = 0.146 * Math.pow(w,2) - 62.008 * w + 6998.8;
    } else if (c < 10999) {
      Wn2 = 10999;
      Wn1 = 9001;
      Wnb = 0.4372 * Math.pow(w,2) - 101.38 * w + 10999;
      Wna = 0.2736 * Math.pow(w,2) - 84.668 * w + 9000.9;
    }
  } else if (w < 0) {
    var Wn2 = 13006;
    var Wn1 = 10999;
    var Wnb = 99.37 * Math.abs(w) + 13006;
    var Wna = -0.6061 * Math.pow(Math.abs(w),2) + 102.18 * Math.abs(w) + 10999;
    if (c < 6999) {
      Wn2 = 6999;
      Wn1 = 3999;
      Wnb = 0.1488 * Math.pow(Math.abs(w),2) + 65.035 * Math.abs(w) + 6998.8;
      Wna = 0.0701 * Math.pow(Math.abs(w),2) + 47.596 * Math.abs(w) + 3999;
    } else if (c < 9001) {
      Wn2 = 9001;
      Wn1 = 6999;
      Wnb = 0.1645 * Math.pow(Math.abs(w),2) + 76.664 * Math.abs(w) + 9000.9;
      Wna = 0.1488 * Math.pow(Math.abs(w),2) + 65.035 * Math.abs(w) + 6998.8;
    } else if (c < 10999) {
      Wn2 = 10999;
      Wn1 = 9001;
      Wnb = -0.6061 * Math.pow(Math.abs(w),2) + 102.18 * Math.abs(w) + 10999;
      Wna = 0.1645 * Math.pow(Math.abs(w),2) + 76.664 * Math.abs(w) + 9000.9;
    }
  }
  var cw = linterp(Wna, Wnb, Wn1, Wn2, c);
  return cw;
}

function CFLrcr(c, r) {
  var Wn2 = 13080;
  var Wn1 = 12010;
  var Wnb = 0.4387 * Math.pow(r,2) - 87.29 * r + 14838;
  var Wna = 6.3246 * Math.pow(r,2) - 283.24 * r + 15225;
  if (c < 6020) {
    Wn2 = 6020;
    Wn1 = 4025;
    Wnb = 3.6864 * Math.pow(r,2) - 152.01 * r + 7575.2;
    Wna = 1.0228 * Math.pow(r,2) - 60.618 * r + 4886;
  } else if (c < 8029) {
    Wn2 = 8029;
    Wn1 = 6020;
    Wnb = 4.4493 * Math.pow(r,2) - 188.93 * r + 10077;
    Wna = 3.6864 * Math.pow(r,2) - 152.01 * r + 7575.2;
  } else if (c < 9999) {
    Wn2 = 9999;
    Wn1 = 8029;
    Wnb = 4.1675 * Math.pow(r,2) - 195.97 * r + 12336;
    Wna = 4.4493 * Math.pow(r,2) - 188.93 * r + 10077;
  } else if (c < 12010) {
    Wn2 = 12010;
    Wn1 = 9999;
    Wnb = 6.3246 * Math.pow(r,2) - 283.24 * r + 15225;
    Wna = 4.1675 * Math.pow(r,2) - 195.97 * r + 12336;
  }
  var cr = linterp(Wna, Wnb, Wn1, Wn2, c);
  return cr;
}

function CEFSwind(c, w) {
  if (w > 0) {
    var Wn2 = 150.6;
    var Wn1 = 139.2;
    var Wnb = 0.5323 * w + 150.57;
    var Wna = 0.3502 * w + 139.25;
    if (c < 109.5) {
      Wn2 = 109.5;
      Wn1 = 99.9;
      Wnb = 0.0357 * w + 109.52;
      Wna = 0.0701 * w + 99.944;
    } else if (c < 120.3) {
      Wn2 = 120.3;
      Wn1 = 109.5;
      Wnb = 0.1164 * w + 120.27;
      Wna = 0.0357 * w + 109.52;
    } else if (c < 129.8) {
      Wn2 = 129.8;
      Wn1 = 120.3;
      Wnb = 0.2202 * w + 129.79;
      Wna = 0.1164 * w + 120.27;
    } else if (c < 139.2) {
      Wn2 = 139.2;
      Wn1 = 129.8;
      Wnb = 0.3502 * w + 139.25;
      Wna = 0.2202 * w + 129.79;
    }
  } else if (w < 0) {
    var Wn2 = 150.57;
    var Wn1 = 139.25;
    var Wnb = -0.3346 * Math.abs(w) + 150.67;
    var Wna = -0.2483 * Math.abs(w) + 138.96;
    if (c < 109.52) {
      Wn2 = 109.52;
      Wn1 = 99.94;
      Wnb = -0.2075 * Math.abs(w) + 109.38;
      Wna = -0.3014 * Math.abs(w) + 100.1;
    } else if (c < 120.27) {
      Wn2 = 120.27;
      Wn1 = 109.52;
      Wnb = -0.2011 * Math.abs(w) + 120.25;
      Wna = -0.2075 * Math.abs(w) + 109.38;
    } else if (c < 129.79) {
      Wn2 = 129.79;
      Wn1 = 120.27;
      Wnb = -0.1885 * Math.abs(w) + 129.76;
      Wna = -0.2011 * Math.abs(w) + 120.25;
    } else if (c < 139.25) {
      Wn2 = 139.25;
      Wn1 = 129.79;
      Wnb = -0.2483 * Math.abs(w) + 138.96;
      Wna = -0.1885 * Math.abs(w) + 129.76;
    }
  }
  cw = linterp(Wna, Wnb, Wn1, Wn2, c);
  return cw;
}

function CEFSrcr(c, r) {
  var Wn2 = 159.478;
  var Wn1 = 150.728;
  var Wnb = -0.00050988 * Math.pow(r,3) - 0.08557069 * Math.pow(r,2) + 4.70146318 * r + 102.49944987;
  var Wna = 0.00250485 * Math.pow(r,3) - 0.20917541 * Math.pow(r,2) + 6.19520593 * r + 88.39281466;
  if (c < 150.728) {
    Wn2 = 150.728;
    Wn1 = 139.445;
    Wnb = 0.00250485 * Math.pow(r,3) - 0.20917541 * Math.pow(r,2) + 6.19520593 * r + 88.39281466;
    Wna = 0.00943332 * Math.pow(r,3) - 0.4954721 * Math.pow(r,2) + 9.50250434 * r + 68.29427335;
  }
  if (c < 139.445) {
    Wn2 = 139.445;
    Wn1 = 129.81;
    Wnb = 0.00943332 * Math.pow(r,3) - 0.4954721 * Math.pow(r,2) + 9.50250434 * r + 68.29427335;
    Wna = 0.00899127 * Math.pow(r,3) - 0.50667614 * Math.pow(r,2) + 10.22139493 * r + 53.52607894;
  }
  if (c < 129.81) {
    Wn2 = 129.81;
    Wn1 = 120;
    Wnb = 0.00899127 * Math.pow(r,3) - 0.50667614 * Math.pow(r,2) + 10.22139493 * r + 53.52607894;
    Wna = -0.00224141 * Math.pow(r,3) + 0.03028951 * Math.pow(r,2) + 2.33573562 * r + 77.88090066;
  }
  if (c < 120) {
    Wn2 = 120;
    Wn1 = 109.339;
    Wnb = -0.00224141 * Math.pow(r,3) + 0.03028951 * Math.pow(r,2) + 2.33573562 * r + 77.88090066;
    Wna = 0.00008897 * Math.pow(r,3) - 0.07224385 * Math.pow(r,2) + 3.79523333 * r + 59.18307692;
  }
  if (c < 109.339) {
    Wn2 = 109.339;
    Wn1 = 99.573;
    Wnb = 0.00008897 * Math.pow(r,3) - 0.07224385 * Math.pow(r,2) + 3.79523333 * r + 59.18307692;
    Wna = -0.03745833 * Math.pow(r,2) + 2.62004167 * r + 59.1275;
  }
  var cr = linterp(Wna, Wnb, Wn1, Wn2, c);
  return cr;
}


function vcwind(v, w) {
  if (w > 0) {
    var Wn2 = 200;
    var Wn1 = 190;
    var Wnb = 0.005 * Math.pow(w,2) - 0.5759 * w + 199.78;
    var Wna = 0.0016 * Math.pow(w,2) - 0.339 * w + 189.77;
    if (v < 190) {
      Wn2 = 190;
      Wn1 = 180;
      Wnb = 0.0016 * Math.pow(w,2) - 0.339 * w + 189.77;
      Wna = 0.0012 * Math.pow(w,2) - 0.2176 * w + 179.87;
    }
    if (v < 180) {
      Wn2 = 180;
      Wn1 = 170;
      Wnb = 0.0012 * Math.pow(w,2) - 0.2176 * w + 179.87;
      Wna = 0.0005 * Math.pow(w,2) - 0.1058 * w + 170.02;
    }
    if (v < 170) {
      Wn2 = 170;
      Wn1 = 160;
      Wnb = 0.0005 * Math.pow(w,2) - 0.1058 * w + 170.02;
      Wna = -0.00003 * Math.pow(w,2) - 0.0431 * w + 160.02;
    }
    if (v < 160) {
      Wn2 = 160;
      Wn1 = 145;
      Wnb = -0.00003 * Math.pow(w,2) - 0.0431 * w + 160.02;
      Wna = -0.0002 * Math.pow(w,2) - 0.0234 * w + 145.14;
    }
    if (v < 145) {
      Wn2 = 145;
      Wn1 = 130;
      Wnb = -0.0002 * Math.pow(w,2) - 0.0234 * w + 145.14;
      Wna = -0.0001 * Math.pow(w,2) + 0.0017 * w + 130.18;
    }
  }
  if (w < 0) {
    var Wn2 = 190;
    var Wn1 = 180;
    var Wnb = 0.0035 * Math.pow(Math.abs(w),3) + 0.3389 * Math.abs(w) + 190.09;
    var Wna = 0.0038 * Math.pow(Math.abs(w),3) + 0.1663 * Math.abs(w) + 180.27;
    if (v < 180) {
      Wn2 = 180;
      Wn1 = 170;
      Wnb = 0.0038 * Math.pow(Math.abs(w),3) + 0.1663 * Math.abs(w) + 180.27;
      Wna = 0.0025 * Math.pow(Math.abs(w),3) + 0.04 * Math.abs(w) + 170.22;
    }
    if (v < 170) {
      Wn2 = 170;
      Wn1 = 160;
      Wnb = 0.0025 * Math.pow(Math.abs(w),3) + 0.04 * Math.abs(w) + 170.22;
      Wna = -0.0003 * Math.pow(Math.abs(w),3) + 0.0434 * Math.abs(w) + 160.16;
    }
    if (v < 160) {
      Wn2 = 160;
      Wn1 = 145;
      Wnb = -0.0003 * Math.pow(Math.abs(w),3) + 0.0434 * Math.abs(w) + 160.16;
      Wna = 0.0007 * Math.pow(Math.abs(w),3) + 0.0029 * Math.abs(w) + 145.13;
    }
    if (v < 145) {
      Wn2 = 145;
      Wn1 = 130;
      Wnb = 0.0007 * Math.pow(Math.abs(w),3) + 0.0029 * Math.abs(w) + 145.13;
      Wna = 0.0007 * Math.pow(Math.abs(w),3) - 0.0044 * Math.abs(w) + 130.18;
    }
  }
  var vw = linterp(Wna, Wnb, Wn1, Wn2, v);
  return vw;
}

function DSwindCorrect(DS, w) {
  var d = DS;
  if (w > 0) {
    if (DS < 48.96) {
      DSnow2 = 48.96;
      DSnow1 = 24.82;
      DSw2 = -1.426151443665 * Math.pow(w,4) + 8.530548674098 * Math.pow(w,3) - 15.753365208466 * Math.pow(w,2) + 1.943514390859 * w + 48.958912819736;
      if (w > 3.79) DSw2 = -48.991 * w + 185.82;
      DSw1 = -16.079 * w + 24.818;
      if (w > 1.54) DSw1 = -48.991 * w + 75.6;
    } else if (DS < 75.08) {
      DSnow2 = 75.08;
      DSnow1 = 48.96;
      DSw2 = -1.5090047158708E-03 * Math.pow(w,6) + 3.81581985252524E-02 * Math.pow(w,5) - 0.374752874253318 * Math.pow(w,4) + 1.70741661410284 * Math.pow(w,3) - 3.49099506871425 * Math.pow(w,2) - 1.83721815681202 * w + 75.0822441976388;
      if (w > 9.43) DSw2 = -22.949 * w + 216.4;
      DSw1 = -1.426151443665 * Math.pow(w,4) + 8.530548674098 * Math.pow(w,3) - 15.753365208466 * Math.pow(w,2) + 1.943514390859 * w + 48.958912819736;
      if (w > 3.79) DSw1 = -48.991 * w + 185.82;
    } else if (DS < 99.56) {
      DSnow2 = 99.56;
      DSnow1 = 75.08;
      DSw2 = -1.581793470447E-04 * Math.pow(w,6) + 7.4377545569746E-03 * Math.pow(w,5) - 0.131127404378276 * Math.pow(w,4) + 1.05297170563426 * Math.pow(w,3) - 3.76585890793649 * Math.pow(w,2) + 2.23365756167913 * w + 99.5600738084904;
      if (w > 17.36) DSw1 = -10.227 * w + 177.63;
      DSw1 = -1.5090047158708E-03 * Math.pow(w,6) + 3.81581985252524E-02 * Math.pow(w,5) - 0.374752874253318 * Math.pow(w,4) + 1.70741661410284 * Math.pow(w,3) - 3.49099506871425 * Math.pow(w,2) - 1.83721815681202 * w + 75.0822441976388;
      if (w > 9.43) DSw1 = -22.949 * w + 216.4;
    } else if (DS < 126.65) {
      DSnow2 = 126.65;
      DSnow1 = 99.56;
      DSw2 = 0.000176829451 * Math.pow(w,4) - 0.018530023279 * Math.pow(w,3) + 0.337870587513 * Math.pow(w,2) - 2.839101323377 * w + 126.650549860624;
      if (w > 29.12) DSw2 = -10.227 * w + 300.35;
      DSw1 = -1.581793470447E-04 * Math.pow(w,6) + 7.4377545569746E-03 * Math.pow(w,5) - 0.131127404378276 * Math.pow(w,4) + 1.05297170563426 * Math.pow(w,3) - 3.76585890793649 * Math.pow(w,2) + 2.23365756167913 * w + 99.5600738084904;
      if (w > 17.36) DSw1 = -10.227 * w + 177.63;
    } else if (DS < 150.54) {
      DSnow2 = 150.54;
      DSnow1 = 126.65;
      DSw2 = 6.98251294E-08 * Math.pow(w,6) - 6.2340221332E-06 * Math.pow(w,5) + 1.641312167067E-04 * Math.pow(w,4) - 1.5208472341328E-03 * Math.pow(w,3) + 9.0131153192488E-03 * Math.pow(w,2) - 1.43860703252722 * w + 150.538922657579;
      DSw1 = 0.000176829451 * Math.pow(w,4) - 0.018530023279 * Math.pow(w,3) + 0.337870587513 * Math.pow(w,2) - 2.839101323377 * w + 126.650549860624;
      if (w > 29.12) DSw1 = -10.227 * w + 300.35;
    }
    DSnow = 150.54;
    DSw = 6.98251294E-08 * Math.pow(w,6) - 6.2340221332E-06 * Math.pow(w,5) + 1.641312167067E-04 * Math.pow(w,4) - 1.5208472341328E-03 * Math.pow(w,3) + 9.0131153192488E-03 * Math.pow(w,2) - 1.43860703252722 * w + 150.538922657579;
    d = DS * DSw / DSnow;
    if (DS < 150.54) {
      d = DSw1 + ((DSw2 - DSw1) / (DSnow2 - DSnow1)) * (DS - DSnow1);
    }
  } else if (w < 0) {
    DSnow2 = 150.38;
    DSnow1 = 124.73;
    DSw2 = 1.1463 * Math.abs(w) + 150.3756;
    DSw1 = 1.2169 * Math.abs(w) + 124.7328;
    if (DS < 50.48) {
      DSnow2 = 50.48;
      DSnow1 = 1.13;
      DSw2 = 2.109542943E-07 * Math.pow(Math.abs(w),6) - 2.70650332626E-05 * Math.pow(Math.abs(w),5) + 0.001318321940289 * Math.pow(Math.abs(w),4) - 2.91842530486974E-02 * Math.pow(Math.abs(w),3) + 0.223163205257151 * Math.pow(Math.abs(w),2) + 3.14185560352053 * Math.abs(w) + 50.4755878212163;
      DSw1 = 0.00000073662175 * Math.pow(Math.abs(w),6) - 0.00009430654577 * Math.pow(Math.abs(w),5) + 0.00453179803353 * Math.pow(Math.abs(w),4) - 0.09717881288134 * Math.pow(Math.abs(w),3) + 0.72311139478188 * Math.pow(Math.abs(w),2) + 5.64946124867129 * Math.abs(w) + 1.13378640348674;
    } else if (DS < 75.01) {
      DSnow2 = 75.01;
      DSnow1 = 50.48;
      DSw2 = -0.000000037733 * Math.pow(Math.abs(w),6) + 0.000003531103 * Math.pow(Math.abs(w),5) - 0.000090213033 * Math.pow(Math.abs(w),4) + 0.000174777478 * Math.pow(Math.abs(w),3) - 0.018275326675 * Math.pow(Math.abs(w),2) + 2.698936554554 * Math.abs(w) + 75.01437730664;
      DSw1 = 2.109542943E-07 * Math.pow(Math.abs(w),6) - 2.70650332626E-05 * Math.pow(Math.abs(w),5) + 0.001318321940289 * Math.pow(Math.abs(w),4) - 2.91842530486974E-02 * Math.pow(Math.abs(w),3) + 0.223163205257151 * Math.pow(Math.abs(w),2) + 3.14185560352053 * Math.abs(w) + 50.4755878212163;
    } else if (DS < 99.83) {
      DSnow2 = 99.83;
      DSnow1 = 75.01;
      DSw2 = 0.000008034308 * Math.pow(Math.abs(w),4) - 0.00000249082 * Math.pow(Math.abs(w),3) - 0.02974106972 * Math.pow(Math.abs(w),3) + 2.042443169694 * Math.abs(w) + 99.833543726571;
      DSw1 = -0.000000037733 * Math.pow(Math.abs(w),6) + 0.000003531103 * Math.pow(Math.abs(w),5) - 0.000090213033 * Math.pow(Math.abs(w),4) + 0.000174777478 * Math.pow(Math.abs(w),3) - 0.018275326675 * Math.pow(Math.abs(w),2) + 2.698936554554 * Math.abs(w) + 75.01437730664;
    } else if (DS < 124.73) {
      DSnow2 = 124.73;
      DSnow1 = 99.83;
      DSw2 = 1.2169 * Math.abs(w) + 124.7328;
      DSw1 = 0.000008034308 * Math.pow(Math.abs(w),4) - 0.00000249082 * Math.pow(Math.abs(w),3) - 0.02974106972 * Math.pow(Math.abs(w),2) + 2.042443169694 * Math.abs(w) + 99.833543726571;
    }
    //d = linterp(DSw1, DSw2, DSnow1, DSnow2, DS);
    d = DSw1 + ((DSw2 - DSw1) / (DSnow2 - DSnow1)) * (DS - DSnow1);
  } else {  // (w == 0)
    d = DS;
  }
  
  if (d < 0) {
    d = 0;
  }
  
  return d;
}


function SECG152To200(t, w, a, v, g) {
  /*
    t = temperature
    w = weight
    a = altitude
    v = velocity
    g = gear state ('up'|'dn')
  */
  var i=0; //Prevents i from bouncing up to calling scope.
  var SECGBounds = new Object();
  // SECG152To200 is good from 152KCAS to 200KCAS
  // Find the values to interpolate between for SECG
  var aryTBins = [50,40,30,20,10,0,-10,-20];
  var aryTBounds = pickBounds(t,aryTBins);
  SECGBounds.temperatureLow = aryTBounds[0];
  SECGBounds.temperatureHigh = aryTBounds[1];

  var aryWBins = [14,13,12,11]; 
  var aryWBounds = pickBounds(w/1000, aryWBins);
  SECGBounds.weightLow = aryWBounds[0];
  SECGBounds.weightHigh = aryWBounds[1];

  var aryPBins = [6,5,4,3,2,1,0];  
  var aryPBounds = pickBounds(a / 1000, aryPBins);
  SECGBounds.pressureAltLow = aryPBounds[0];
  SECGBounds.pressureAltHigh = aryPBounds[1];

  var vv2 = 144;
  for (i = 1; i < 29; i++) {
    if (v > vv2) vv2 = vv2 + 2;
  }
  var vv1 = vv2 - 2;
  
  SECGBounds.velocityLow = vv1;
  SECGBounds.velocityHigh = vv2;
  
  // Set interpolating base values
  var weightBase = w / 1000;
  var pressureAltBase = a / 1000;
  var temperatureBase = t + 273.15;
  var velocityBase = v;
  
  var arySECGWeights = [];
  for (i=0; i < 8; i++) {
    arySECGWeights[i] = SECGBounds.weightLow;
    arySECGWeights[i+8] = SECGBounds.weightHigh;
  }

  var arySECGPressureAlts = [];
  for (i=0; i < 4; i++) {
    arySECGPressureAlts[i] = SECGBounds.pressureAltLow;
    arySECGPressureAlts[i+4] = SECGBounds.pressureAltHigh;
    arySECGPressureAlts[i+8] = SECGBounds.pressureAltLow;
    arySECGPressureAlts[i+12] = SECGBounds.pressureAltHigh;
  }

  var arySECGTemperatures = [];
  for (i=0; i < 13; i = i + 4) {
    arySECGTemperatures[i] = SECGBounds.temperatureLow;
    arySECGTemperatures[i+1] = SECGBounds.temperatureLow;
    arySECGTemperatures[i+2] = SECGBounds.temperatureHigh;
    arySECGTemperatures[i+3] = SECGBounds.temperatureHigh;
  }
 
  var arySECGTemperaturesK = [];
  for (i=0;i< 16;i++) {
    arySECGTemperaturesK[i] = TC2K(arySECGTemperatures[i]);
  }
    
  var arySECGVelocities = [];
  for (i=0; i < 15; i = i + 2) {
    arySECGVelocities[i] = SECGBounds.velocityLow;
    arySECGVelocities[i+1] = SECGBounds.velocityHigh;
  }

  //Calculate TWAV values
  var aryTWAVs = [];
  for (i=0;i < 16;i++) {
    aryTWAVs[i] = (arySECGTemperaturesK[i] * Math.pow(10,9) + arySECGWeights[i] * Math.pow(10,5) + arySECGPressureAlts[i] * Math.pow(10,3) + arySECGVelocities[i]).toFixed(0);
  }
 
  // Do lookups against SECGGU data (if gear is up) using TWAV keys; else use SECG data
  var arySECGBase = [];
  for (i=0; i < aryTWAVs.length; i++) {
    if (g.toLowerCase() == 'up') {
      arySECGBase[i] = SECGGUData[aryTWAVs[i]];
    } else {
      arySECGBase[i] = SECGData[aryTWAVs[i]][0];
    }
  }

  // Now do the interpolations and return the resulting SECG value
  // Interpolate with Weight as the factor (8 results)
  var arySECGInterpByWeight = [];
  for (i=0; i < 8; i++) {
    arySECGInterpByWeight[i] = linterp(arySECGBase[i], arySECGBase[i+8], arySECGWeights[i], arySECGWeights[i+8], weightBase);
  }      
    
  // Interpolate with pressureAlt as the factor (4 results)
  var arySECGInterpByPressureAlt = [];
  for (i=0; i < 4;i++) {
    arySECGInterpByPressureAlt[i] = linterp(arySECGInterpByWeight[i], arySECGInterpByWeight[i+4], arySECGPressureAlts[i], arySECGPressureAlts[i+4], pressureAltBase);    
  }

  // Interpolate with Temperature as the factor (2 results)
  var arySECGInterpByTemperature = [];
  for (i=0; i < 2;i++) {
    arySECGInterpByTemperature[i] = linterp(arySECGInterpByPressureAlt[i], arySECGInterpByPressureAlt[i+2], arySECGTemperaturesK[i], arySECGTemperaturesK[i+2], temperatureK);    
  }

  // Interpolate with Velcocity as the factor (1 result)
  var s = linterp(arySECGInterpByTemperature[0], arySECGInterpByTemperature[1], arySECGVelocities[0], arySECGVelocities[1], velocityBase);

  return s;
}

function rsbeo(t, a, r, wt, w, rc, ab) {
  var del = rho(pressureAlt, temperature) / rho(0, 15);
  //Finds the 2 runway lengths to interpolate between
  //Define as r1 and r2
  var rBins = [15000,14000,13000,12000,11000,10000,9000,8000,7000];
  var aryRs = pickBounds(r,rBins);
  var r1 = aryRs[0];
  var r2 = aryRs[1];
  
  switch(r1) { 
    case 7000: 
      var rsbeo1 = 94.352 * Math.pow(del,3) - 293.43 * Math.pow(del,2) + 316.33 * del - 14.094;
      break;
    case 8000: 
      var rsbeo1 = 66.158 * Math.pow(del,3) - 216.33 * Math.pow(del,2) + 240.87 * del + 16.291;
      break;
    case 9000: 
      var rsbeo1 = 40.929 * Math.pow(del,3) - 130.76 * Math.pow(del,2) + 146.11 * del + 55.814;
      break;
    case 10000: 
      var rsbeo1 = 45.389 * Math.pow(del,3) - 140.93 * Math.pow(del,2) + 151.88 * del + 59.034;
      break;
    case 11000: 
      var rsbeo1 = 34.061 * Math.pow(del,3) - 114.5 * Math.pow(del,2) + 140.2 * del + 60.71;
      break;
    case 12000: 
      var rsbeo1 = 9.71 * Math.pow(del,3) - 37.632 * Math.pow(del,2) + 66.296 * del + 87.346;
      break;
    case 13000: 
      var rsbeo1 = 14.965 * Math.pow(del,3) - 55.926 * Math.pow(del,2) + 90.622 * del + 80.627;
      break;
    case 14000: 
      var rsbeo1 = 22.431 * Math.pow(del,3) - 82.102 * Math.pow(del,2) + 123.87 * del + 70.125;
      break;
    case 15000: 
      var rsbeo1 = 27.335 * Math.pow(del,3) - 97.251 * Math.pow(del,2) + 141.52 * del + 67.065;
      break;
  }
  
  switch(r2) {   
    case 7000:  
      var rsbeo2 = 94.352 * Math.pow(del,3) - 293.43 * Math.pow(del,2) + 316.33 * del - 14.094;
      break;
    case 8000:  
      var rsbeo2 = 66.158 * Math.pow(del,3) - 216.33 * Math.pow(del,2) + 240.87 * del + 16.291;
      break;
    case 9000:  
      var rsbeo2 = 40.929 * Math.pow(del,3) - 130.76 * Math.pow(del,2) + 146.11 * del + 55.814;
      break;
    case 10000: 
      var rsbeo2 = 45.389 * Math.pow(del,3) - 140.93 * Math.pow(del,2) + 151.88 * del + 59.034;
      break;
    case 11000: 
      var rsbeo2 = 34.061 * Math.pow(del,3) - 114.5 * Math.pow(del,2) + 140.2 * del + 60.71;
      break;
    case 12000: 
      var rsbeo2 = 9.71 * Math.pow(del,3) - 37.632 * Math.pow(del,2) + 66.296 * del + 87.346  ;
      break;
    case 13000: 
      var rsbeo2 = 14.965 * Math.pow(del,3) - 55.926 * Math.pow(del,2) + 90.622 * del + 80.627;
      break;
    case 14000: 
      var rsbeo2 = 22.431 * Math.pow(del,3) - 82.102 * Math.pow(del,2) + 123.87 * del + 70.125;
      break;
    case 15000: 
      var rsbeo2 = 27.335 * Math.pow(del,3) - 97.251 * Math.pow(del,2) + 141.52 * del + 67.065;
      break;
  }
  
  var rsbeo = linterp(rsbeo1,rsbeo2,r1,r2,r);
  
  if (ab == 1) {
    if (rsbeo > 110) {
      ABT = -3.2143 * Math.pow(rsbeo,2) + 915.71 * rsbeo - 51041;  //if weight is < ABT then ab
      if (r >= 10000) {
        if (wt < ABT) {
          switch(r1) {
            case 10000: 
              rsbeo1 = 0.074848 * Math.pow(rsbeo,3) - 24.841856 * Math.pow(rsbeo,2) + 2750.441041 * rsbeo - 101477.358058;
              break;
            case 11000: 
              rsbeo1 = 0.214604 * Math.pow(rsbeo,2) - 47.515273 * rsbeo + 2743.581816;
              break;
            case 12000: 
              rsbeo1 = 0.00044 * Math.pow(rsbeo,3) + 0.009564 * Math.pow(rsbeo,2) - 19.018696 * rsbeo + 1510.313506;
              break;
            case 13000: 
              rsbeo1 = 0.142319 * Math.pow(rsbeo,2) - 32.885743 * rsbeo + 2020.561564;
              break;
            case 14000: 
              rsbeo1 = 0.032518 * Math.pow(rsbeo,2) - 5.128512 * rsbeo + 261.432749;
              break;
            case 15000: 
              rsbeo1 = -0.000216 * Math.pow(rsbeo,3) + 0.03482 * Math.pow(rsbeo,2) + 6.128404 * rsbeo - 773.24905;
              break;
          }
          switch(r2) {     
            case 10000: 
              rsbeo2 = 0.074848 * Math.pow(rsbeo,3) - 24.841856 * Math.pow(rsbeo,2) + 2750.441041 * rsbeo - 101477.358058;
              break;
            case 11000: 
              rsbeo2 = 0.214604 * Math.pow(rsbeo,2) - 47.515273 * rsbeo + 2743.581816;
              break;
            case 12000: 
              rsbeo2 = 0.00044 * Math.pow(rsbeo,3) + 0.009564 * Math.pow(rsbeo,2) - 19.018696 * rsbeo + 1510.313506;
              break;
            case 13000: 
              rsbeo2 = 0.142319 * Math.pow(rsbeo,2) - 32.885743 * rsbeo + 2020.561564;
              break;
            case 14000: 
              rsbeo2 = 0.032518 * Math.pow(rsbeo,2) - 5.128512 * rsbeo + 261.432749;
              break;
            case 15000: 
              rsbeo2 = -0.000216 * Math.pow(rsbeo,3) + 0.03482 * Math.pow(rsbeo,2) + 6.128404 * rsbeo - 773.24905;
              break;
          }
        }
      }
    }
  }
  
  if (w >= 0) {
    rsbeo = linterp(rsbeo1,rsbeo2,r1,r2,r) + w / 2;
  }
  if (w < 0) rsbeo = rsbeo + 0.7 * w;
  return rsbeo; 
}

function rsef(t, a, r, wt, w, rc, ab) {
  var RSFlag = 0;
  del = rho(a, t) / rho(0, 15);
  //These curve fits are made to match the chart not the raw data
  //Finds the 2 runway lengths to interpolate between
  //Define as r1 and r2
  var rBins = [15000,14000,13000,12000,11000,10000,9000,8000,7000];
  var aryRs = pickBounds(r,rBins);
  var r1 = aryRs[0];
  var r2 = aryRs[1];
  
  switch(r1) {
    case 7000:  
      rsef1 = 106.31 * Math.pow(del,3) - 341.6 * Math.pow(del,2) + 383.67 * del - 31.697;
      break;
    case 8000:  
      rsef1 = 60.005 * Math.pow(del,3) - 199.06 * Math.pow(del,2) + 238.88 * del + 21.881;
      break;
    case 9000:  
      rsef1 = 77.64 * Math.pow(del,3) - 250.58 * Math.pow(del,2) + 290.63 * del + 9.5729;
      break;
    case 10000: 
      rsef1 = 9.6531 * Math.pow(del,3) - 40.389 * Math.pow(del,2) + 84.117 * del + 78.468;
      break;
    case 11000: 
      rsef1 = 12.568 * Math.pow(del,3) - 51.826 * Math.pow(del,2) + 103.4 * del + 72.133;
      break;
    case 12000: 
      rsef1 = 20.377 * Math.pow(del,3) - 80.523 * Math.pow(del,2) + 144.51 * del + 56.929;
      break;
    case 13000: 
      rsef1 = 36.194 * Math.pow(del,3) - 134.22 * Math.pow(del,2) + 211.5 * del + 33.112;
      break;
    case 14000: 
      rsef1 = 32.5 * Math.pow(del,3) - 119.07 * Math.pow(del,2) + 189.59 * del + 47.882;
      break;
    case 15000: 
      rsef1 = 61.225 * Math.pow(del,3) - 215.58 * Math.pow(del,2) + 308.11 * del + 2.7883;
      break;
  }

  switch(r2) {  
    case 7000:  
      rsef2 = 106.31 * Math.pow(del,3) - 341.6 * Math.pow(del,2) + 383.67 * del - 31.697;
      break;
    case 8000:  
      rsef2 = 60.005 * Math.pow(del,3) - 199.06 * Math.pow(del,2) + 238.88 * del + 21.881;
      break;
    case 9000:  
      rsef2 = 77.64 * Math.pow(del,3) - 250.58 * Math.pow(del,2) + 290.63 * del + 9.5729;
      break;
    case 10000: 
      rsef2 = 9.6531 * Math.pow(del,3) - 40.389 * Math.pow(del,2) + 84.117 * del + 78.468;
      break;
    case 11000: 
      rsef2 = 12.568 * Math.pow(del,3) - 51.826 * Math.pow(del,2) + 103.4 * del + 72.133;
      break;
    case 12000: 
      rsef2 = 20.377 * Math.pow(del,3) - 80.523 * Math.pow(del,2) + 144.51 * del + 56.929;
      break;
    case 13000: 
      rsef2 = 36.194 * Math.pow(del,3) - 134.22 * Math.pow(del,2) + 211.5 * del + 33.112;
      break;
    case 14000: 
      rsef2 = 32.5 * Math.pow(del,3) - 119.07 * Math.pow(del,2) + 189.59 * del + 47.882;
      break;
    case 15000: 
      rsef2 = 61.225 * Math.pow(del,3) - 215.58 * Math.pow(del,2) + 308.11 * del + 2.7883;
      break;
  }

  rsef = linterp(rsef1,rsef2,r1,r2,r);

  if (ab == 1) {
    if (rsef > 105) {
      ABT = 13454 * Math.log(rsef) - 51937; //if weight is < ABT then ab
      if (wt < ABT) {
        rsef = rsef - 120;
        switch(r1) {
          case 7000:
            rsef1 = 0.0178 * Math.pow(rsef,3) + 0.5297 * Math.pow(rsef,2) + 5.4009 * rsef + 128.89;
            if (rsef + 120 > 140) RSFlag = 1;
            break;
          case 8000:
            rsef1 = 0.0191 * Math.pow(rsef,3) + 0.2302 * Math.pow(rsef,2) + 2.2737 * rsef + 119.22;
            if (rsef + 120 > 155) RSFlag = 1;
            break;
          case 9000:
            rsef1 = -0.0115 * Math.pow(rsef,3) + 0.3265 * Math.pow(rsef,2) + 1.0505 * rsef + 115.48;
            if (rsef + 120 > 137) RSFlag = 1;
            break;
          case 10000:
            rsef1 = 0.00435 * Math.pow(rsef,4) - 0.16053 * Math.pow(rsef,3) + 1.97271 * Math.pow(rsef,2) - 6.7066 * rsef + 124.72273;
            if (rsef + 120 > 143) RSFlag = 1;
            break;
          case 11000:
            rsef1 = 0.0043 * Math.pow(rsef,3) - 0.1391 * Math.pow(rsef,2) + 3.7029 * rsef + 104.93;
            if (rsef + 120 > 147) RSFlag = 1;
            break;
          case 12000:
            rsef1 = 0.001 * Math.pow(rsef,3) - 0.0191 * Math.pow(rsef,2) + 2.1366 * rsef + 109.69;
            if (rsef + 120 > 153) RSFlag = 1;
            break;
          case 13000:
            rsef1 = -0.0016 * Math.pow(rsef,3) + 0.121 * Math.pow(rsef,2) - 0.4696 * rsef + 122.9;
            if (rsef + 120 > 159) RSFlag = 1;
            break;
          case 14000:
            rsef1 = -0.0011 * Math.pow(rsef,3) + 0.082 * Math.pow(rsef,2) + 0.2461 * rsef + 117.42;
            if (rsef + 120 > 165) RSFlag = 1;
            break;
          case 15000:
            rsef1 = 2.2643 * rsef + 98.217;
            if (rsef + 120 > 170) RSFlag = 1;
            break;
        }
            
        switch(r2) {
          case 7000:
            rsef2 = 0.0178 * Math.pow(rsef,3) + 0.5297 * Math.pow(rsef,2) + 5.4009 * rsef + 128.89;
            if (rsef + 120 > 140) RSFlag = 1;
            break;
          case 8000:
            rsef2 = 0.0191 * Math.pow(rsef,3) + 0.2302 * Math.pow(rsef,2) + 2.2737 * rsef + 119.22;
            if (rsef + 120 > 155) RSFlag = 1;
            break;
          case 9000:
            rsef2 = -0.0115 * Math.pow(rsef,3) + 0.3265 * Math.pow(rsef,2) + 1.0505 * rsef + 115.48;
            if (rsef + 120 > 137) RSFlag = 1;
            break;
          case 10000:
            rsef2 = 0.00435 * Math.pow(rsef,4) - 0.16053 * Math.pow(rsef,3) + 1.97271 * Math.pow(rsef,2) - 6.7066 * rsef + 124.72273;
            if (rsef + 120 > 143) RSFlag = 1;
            break;
          case 11000:
            rsef2 = 0.0043 * Math.pow(rsef,3) - 0.1391 * Math.pow(rsef,2) + 3.7029 * rsef + 104.93;
            if (rsef + 120 > 147) RSFlag = 1;
            break;
          case 12000:
            rsef2 = 0.001 * Math.pow(rsef,3) - 0.0191 * Math.pow(rsef,2) + 2.1366 * rsef + 109.69;
            if (rsef + 120 > 153) RSFlag = 1;
            break;
          case 13000:
            rsef2 = -0.0016 * Math.pow(rsef,3) + 0.121 * Math.pow(rsef,2) - 0.4696 * rsef + 122.9;
            if (rsef + 120 > 159) RSFlag = 1;
            break;
          case 14000:
            rsef2 = -0.0011 * Math.pow(rsef,3) + 0.082 * Math.pow(rsef,2) + 0.2461 * rsef + 117.42;
            if (rsef + 120 > 165) RSFlag = 1;
            break;
          case 15000:
            rsef2 = 2.2643 * rsef + 98.217;
            if (rsef + 120 > 170) RSFlag = 1;
            break;
        }
        rsef = rsef + 120;
      }
    }
  }
  
  if (w >= 0) {
    rsef = rsef1 * 1.0 + ((rsef2 - rsef1) / (r2 - r1)) * (r - r1) + w / 2;
  }
  if (w < 0) rsef = rsef * 1.0 + 0.7 * w;
  if (RSFlag == 1) rsef = 240; // RS > Rotation speed
  return rsef;
}

function rsRCR(rs, rc, w) {
  //Finds the 2 rc lines to interpolate between
  //Define as rs1 and rs2
  var rs2 = 160;
  var rs1 = 151;
  if (rs < 110) {
    rs2 = 110;
    rs1 = 100;
  } else if (rs < 122) {
    rs2 = 122;
    rs1 = 110;
  } else if (rs < 130) {
    rs2 = 130;
    rs1 = 122;
  } else if (rs < 140) {
    rs2 = 140;
    rs1 = 130;
  } else if (rs < 151) {
    rs2 = 151;
    rs1 = 140;
  }
  
  if (rs1 == 100) rsx = 0.00786678 * Math.pow(rc,3) - 0.46972344 * Math.pow(rc,2) + 10.83396792 * rc + 3.38643049;
  if (rs1 == 110) rsx = 0.00900996 * Math.pow(rc,3) - 0.54845835 * Math.pow(rc,2) + 12.1639564 * rc + 10.3940685;
  if (rs1 == 122) rsx = 0.00762142 * Math.pow(rc,3) - 0.46236314 * Math.pow(rc,2) + 10.73547052 * rc + 26.75878545;
  if (rs1 == 130) rsx = 0.00540013 * Math.pow(rc,3) - 0.33621253 * Math.pow(rc,2) + 8.7780173 * rc + 40.05840962;
  if (rs1 == 140) rsx = 0.01084565 * Math.pow(rc,3) - 0.58532172 * Math.pow(rc,2) + 12.47876482 * rc + 30.76543469;
  if (rs1 == 151) rsx = 0.01147064 * Math.pow(rc,3) - 0.64630723 * Math.pow(rc,2) + 14.17684017 * rc + 27.33964535;
  
  if (rs2 == 110) rsy = 0.00900996 * Math.pow(rc,3) - 0.54845835 * Math.pow(rc,2) + 12.1639564 * rc + 10.3940685;
  if (rs2 == 122) rsy = 0.00762142 * Math.pow(rc,3) - 0.46236314 * Math.pow(rc,2) + 10.73547052 * rc + 26.75878545;
  if (rs2 == 130) rsy = 0.00540013 * Math.pow(rc,3) - 0.33621253 * Math.pow(rc,2) + 8.7780173 * rc + 40.05840962;
  if (rs2 == 140) rsy = 0.01084565 * Math.pow(rc,3) - 0.58532172 * Math.pow(rc,2) + 12.47876482 * rc + 30.76543469;
  if (rs2 == 151) rsy = 0.01147064 * Math.pow(rc,3) - 0.64630723 * Math.pow(rc,2) + 14.17684017 * rc + 27.33964535;
  if (rs2 == 160) rsy = 0.01955011 * Math.pow(rc,3) - 1.05823639 * Math.pow(rc,2) + 20.63805346 * rc + 7.66011159;
  
  var rsrc = linterp (rsx,rsy,rs1,rs2,rs);
  return rsrc; 
}

function NACS1(z, t, m, w) {
  // first find the two guideslines to interpolate between
  var GRD1 = 0.000003513905 * Math.pow(t,4) - 0.000708033124 * Math.pow(t,3) + 0.294130990555 * Math.pow(t,2) - 1.892912089745 * t;
  var GRD2 = 0.000011226151 * Math.pow(t,4) - 0.003104399026 * Math.pow(t,3) + 0.464938794735 * Math.pow(t,2) - 7.530705053214 * t;
  var GRD3 = 0.000005249426 * Math.pow(t,4) - 0.00134507761 * Math.pow(t,3) + 0.273630954536 * Math.pow(t,2) - 3.579713385559 * t;
  var GRD4 = 0.000003139945 * Math.pow(t,4) - 0.0008795172 * Math.pow(t,3) + 0.216810740448 * Math.pow(t,2) - 3.009328481741 * t;
  var GRD5 = 0.000000495158 * Math.pow(t,4) - 0.000014723875 * Math.pow(t,3) + 0.098981038297 * Math.pow(t,2) + 0.445409534466 * t - 10.007056332394;
  var GRD6 = 0.000000515684 * Math.pow(t,4) - 0.000112485344 * Math.pow(t,3) + 0.09658259448 * Math.pow(t,2) - 0.650017446329 * t + 0.5299495412;
  var GRD7 = 0.000000523946 * Math.pow(t,4) - 0.000166434536 * Math.pow(t,3) + 0.087305009565 * Math.pow(t,2) - 0.961789399117 * t - 6.917025485388;
  var macsin = m / 1000;
  var TODin = z / 1000;
  
  var N2 = -0.02490955133 * Math.pow(macsin,6) + 0.571235476909 * Math.pow(macsin,5) - 5.141518947261 * Math.pow(macsin,4) + 23.13665916922 * Math.pow(macsin,3) - 56.206878061406 * Math.pow(macsin,2) + 91.747328514699 * macsin + 12.748473197084;
  var N1 = -0.016813885871 * Math.pow(macsin,6) + 0.399683544983 * Math.pow(macsin,5) - 3.733522691444 * Math.pow(macsin,4) + 17.454038136872 * Math.pow(macsin,3) - 44.960364592494 * Math.pow(macsin,2) + 85.419421822997 * macsin + 18.661163609373;
  var NT2 = -0.02490955133 * Math.pow(TODin,6) + 0.571235476909 * Math.pow(TODin,5) - 5.141518947261 * Math.pow(TODin,4) + 23.13665916922 * Math.pow(TODin,3) - 56.206878061406 * Math.pow(TODin,2) + 91.747328514699 * TODin + 12.748473197084;
  var NT1 = -0.016813885871 * Math.pow(TODin,6) + 0.399683544983 * Math.pow(TODin,5) - 3.733522691444 * Math.pow(TODin,4) + 17.454038136872 * Math.pow(TODin,3) - 44.960364592494 * Math.pow(TODin,2) + 85.419421822997 * TODin + 18.661163609373;
  if (TODin < GRD2 / 1000) {
    N2 = -0.016813885871 * Math.pow(macsin,6) + 0.399683544983 * Math.pow(macsin,5) - 3.733522691444 * Math.pow(macsin,4) + 17.454038136872 * Math.pow(macsin,3) - 44.960364592494 * Math.pow(macsin,2) + 85.419421822997 * macsin + 18.661163609373;
    N1 = -0.023748484645 * Math.pow(macsin,6) + 0.549022831932 * Math.pow(macsin,5) - 4.954513604927 * Math.pow(macsin,4) + 22.307163981372 * Math.pow(macsin,3) - 55.372635773849 * Math.pow(macsin,2) + 99.422558822902 * macsin + 19.346083253244;
    NT2 = -0.016813885871 * Math.pow(TODin,6) + 0.399683544983 * Math.pow(TODin,5) - 3.733522691444 * Math.pow(TODin,4) + 17.454038136872 * Math.pow(TODin,3) - 44.960364592494 * Math.pow(TODin,2) + 85.419421822997 * TODin + 18.661163609373;
    NT1 = -0.023748484645 * Math.pow(TODin,6) + 0.549022831932 * Math.pow(TODin,5) - 4.954513604927 * Math.pow(TODin,4) + 22.307163981372 * Math.pow(TODin,3) - 55.372635773849 * Math.pow(TODin,2) + 99.422558822902 * TODin + 19.346083253244;
  }
  if (TODin < GRD3 / 1000) {
    N2 = -0.023748484645 * Math.pow(macsin,6) + 0.549022831932 * Math.pow(macsin,5) - 4.954513604927 * Math.pow(macsin,4) + 22.307163981372 * Math.pow(macsin,3) - 55.372635773849 * Math.pow(macsin,2) + 99.422558822902 * macsin + 19.346083253244;
    N1 = -0.05194190336 * Math.pow(macsin,6) + 1.013929433277 * Math.pow(macsin,5) - 7.733304201742 * Math.pow(macsin,4) + 29.591297884239 * Math.pow(macsin,3) - 63.686004101299 * Math.pow(macsin,2) + 106.429727414622 * macsin + 22.521497901093;
    NT2 = -0.023748484645 * Math.pow(TODin,6) + 0.549022831932 * Math.pow(TODin,5) - 4.954513604927 * Math.pow(TODin,4) + 22.307163981372 * Math.pow(TODin,3) - 55.372635773849 * Math.pow(TODin,2) + 99.422558822902 * TODin + 19.346083253244;
    NT1 = -0.05194190336 * Math.pow(TODin,6) + 1.013929433277 * Math.pow(TODin,5) - 7.733304201742 * Math.pow(TODin,4) + 29.591297884239 * Math.pow(TODin,3) - 63.686004101299 * Math.pow(TODin,2) + 106.429727414622 * TODin + 22.521497901093;
  }
  if (TODin < GRD4 / 1000) {
    N2 = -0.05194190336 * Math.pow(macsin,6) + 1.013929433277 * Math.pow(macsin,5) - 7.733304201742 * Math.pow(macsin,4) + 29.591297884239 * Math.pow(macsin,3) - 63.686004101299 * Math.pow(macsin,2) + 106.429727414622 * macsin + 22.521497901093;
    N1 = -0.177521800102 * Math.pow(macsin,6) + 2.810942643089 * Math.pow(macsin,5) - 17.618466831977 * Math.pow(macsin,4) + 56.310237428173 * Math.pow(macsin,3) - 101.98916299967 * Math.pow(macsin,2) + 138.37646388472 * macsin + 19.548883476324;
    NT2 = -0.05194190336 * Math.pow(TODin,6) + 1.013929433277 * Math.pow(TODin,5) - 7.733304201742 * Math.pow(TODin,4) + 29.591297884239 * Math.pow(TODin,3) - 63.686004101299 * Math.pow(TODin,2) + 106.429727414622 * TODin + 22.521497901093;
    NT1 = -0.177521800102 * Math.pow(TODin,6) + 2.810942643089 * Math.pow(TODin,5) - 17.618466831977 * Math.pow(TODin,4) + 56.310237428173 * Math.pow(TODin,3) - 101.98916299967 * Math.pow(TODin,2) + 138.37646388472 * TODin + 19.548883476324;
  }
  if (TODin < GRD5 / 1000) {
    N2 = -0.177521800102 * Math.pow(macsin,6) + 2.810942643089 * Math.pow(macsin,5) - 17.618466831977 * Math.pow(macsin,4) + 56.310237428173 * Math.pow(macsin,3) - 101.98916299967 * Math.pow(macsin,2) + 138.37646388472 * macsin + 19.548883476324;
    N1 = -1.085967955893 * Math.pow(macsin,6) + 13.05710630212 * Math.pow(macsin,5) - 61.428669347428 * Math.pow(macsin,4) + 144.820947027765 * Math.pow(macsin,3) - 188.709166983142 * Math.pow(macsin,2) + 181.656963294604 * macsin + 19.911275952793;
    NT2 = -0.177521800102 * Math.pow(TODin,6) + 2.810942643089 * Math.pow(TODin,5) - 17.618466831977 * Math.pow(TODin,4) + 56.310237428173 * Math.pow(TODin,3) - 101.98916299967 * Math.pow(TODin,2) + 138.37646388472 * TODin + 19.548883476324;
    NT1 = -1.085967955893 * Math.pow(TODin,6) + 13.05710630212 * Math.pow(TODin,5) - 61.428669347428 * Math.pow(TODin,4) + 144.820947027765 * Math.pow(TODin,3) - 188.709166983142 * Math.pow(TODin,2) + 181.656963294604 * TODin + 19.911275952793;
  }
  if (TODin < GRD6 / 1000) {
    N2 = -1.085967955893 * Math.pow(macsin,6) + 13.05710630212 * Math.pow(macsin,5) - 61.428669347428 * Math.pow(macsin,4) + 144.820947027765 * Math.pow(macsin,3) - 188.709166983142 * Math.pow(macsin,2) + 181.656963294604 * macsin + 19.911275952793;
    N1 = -3.543353351881 * Math.pow(macsin,6) + 31.853669395604 * Math.pow(macsin,5) - 112.444671454714 * Math.pow(macsin,4) + 202.224508703759 * Math.pow(macsin,3) - 212.206770264745 * Math.pow(macsin,2) + 191.06411791069 * macsin + 25.793333788857;
    NT2 = -1.085967955893 * Math.pow(TODin,6) + 13.05710630212 * Math.pow(TODin,5) - 61.428669347428 * Math.pow(TODin,4) + 144.820947027765 * Math.pow(TODin,3) - 188.709166983142 * Math.pow(TODin,2) + 181.656963294604 * TODin + 19.911275952793;
    NT1 = -3.543353351881 * Math.pow(TODin,6) + 31.853669395604 * Math.pow(TODin,5) - 112.444671454714 * Math.pow(TODin,4) + 202.224508703759 * Math.pow(TODin,3) - 212.206770264745 * Math.pow(TODin,2) + 191.06411791069 * TODin + 25.793333788857;
  }
  n = linterp(N1,N2,NT1,NT2,t);
  n = n * 1 + w * 1;
  return n;
}

function MACS1(n, c, r) {
  var excessRW = r - c;
  var m = n - 3 * excessRW / 1000;
  if (n - m > 10) m = n - 10;
  return m;
}

function distwind(b, w) { // adjusts the initial ground distance in Ground run SE
  if (w > 0) { // use headw guidelines
    var WW2 = 28444.3;
    var WW1 = 22086.8;
    var wwb = 0.15021626 * Math.pow(w,2) - 178.51456329 * w + 28144.25538656;
    var wwa = 0.17361569 * Math.pow(w,2) - 151.87369681 * w + 22086.835927;
    if (b < 12065.7) {
      WW2 = 10265.7;
      WW1 = 6069.7;
      wwb = 0.18915153 * Math.pow(w,2) - 108.00864423 * w + 12065.70194848;
      wwa = 0.175143 * Math.pow(w,2) - 73.42119703 * w + 6069.74201243;
    } else if (b < 22086.8) {
      WW2 = 22086.8;
      WW1 = 12065.7;
      wwb = 0.17361569 * Math.pow(w,2) - 151.87369681 * w + 22086.835927;
      wwa = 0.18915153 * Math.pow(w,2) - 108.00864423 * w + 12065.70194848;
    }
  } else if (w < 0) { //use tailw guidelines
    var WW2 = 21974.4;
    var WW1 = 11998.2;
    var wwb = 0.26529461 * Math.pow(w,2) - 150.80371898 * w + 21974.38500989;
    var wwa = 0.20656323 * Math.pow(w,2) - 107.54303891 * w + 11998.21401915;
    if (b < 11998.2) {
      WW2 = 11998.2;
      WW1 = 6037.7;
      wwb = 0.20656323 * Math.pow(w,2) - 107.54303891 * w + 11998.21401915;
      wwa = 0.22551124 * Math.pow(w,2) - 75.46320883 * w + 6037.71420071;
    }
  }
  dw = linterp(wwa,wwb,WW1,WW2,b);
  return dw;
}

function distreq(s, v, b) { //finds dsitance required to accelerate from EF to SETOS
  // first find the two guideslines to interpolate between
  v = v / 100;
  s = s / 100;
  
  var vin2 = 4020.11436254 * Math.pow(v,5) - 16206.06759548 * Math.pow(v,4) + 24807.3251466799 * Math.pow(v,3) - 11400.4034152 * Math.pow(v,2) + 2399.52785391 * v;
  var vin1 = 90808.30098438 * Math.pow(v,5) - 178372.97923088 * Math.pow(v,4) + 134421.30867577 * Math.pow(v,3) - 25604.69337463 * Math.pow(v,2) + 2422.42866802 * v;
  var set2 = 4020.11436254 * Math.pow(s,5) - 16206.06759548 * Math.pow(s,4) + 24807.3251466799 * Math.pow(s,3) - 11400.4034152 * Math.pow(s,2) + 2399.52785391 * s;
  var set1 = 90808.30098438 * Math.pow(s,5) - 178372.97923088 * Math.pow(s,4) + 134421.30867577 * Math.pow(s,3) - 25604.69337463 * Math.pow(s,2) + 2422.42866802 * s;
  var NT2 = 27002;
  var NT1 = 23674;
  if (b < 9590) {
    vin2 = 714.37893814 * Math.pow(v,3) + 1012.30599624 * Math.pow(v,2) - 87.11530206 * v;
    vin1 = 534.14088343 * Math.pow(v,3) + 1014.39681758 * Math.pow(v,2) - 129.34359137 * v;
    set2 = 714.37893814 * Math.pow(s,3) + 1012.30599624 * Math.pow(s,2) - 87.11530206 * s;
    set1 = 534.14088343 * Math.pow(s,3) + 1014.39681758 * Math.pow(s,2) - 129.34359137 * s;
    NT2 = 9590;
    NT1 = 8072;
  } else if (b < 10656) {
    vin2 = 173.90344176 * Math.pow(v,5) - 201.54790866 * Math.pow(v,4) - 365.67345333 * Math.pow(v,3) + 3388.92252588 * Math.pow(v,2) - 1157.29229832 * v;
    vin1 = 714.37893814 * Math.pow(v,3) + 1012.30599624 * Math.pow(v,2) - 87.11530206 * v;
    set2 = 173.90344176 * Math.pow(s,5) - 201.54790866 * Math.pow(s,4) - 365.67345333 * Math.pow(s,3) + 3388.92252588 * Math.pow(s,2) - 1157.29229832 * s;
    set1 = 714.37893814 * Math.pow(s,3) + 1012.30599624 * Math.pow(s,2) - 87.11530206 * s;
    NT2 = 10656;
    NT1 = 9590;
  } else if (b < 11749) {
    vin2 = 236.62002924 * Math.pow(v,5) - 410.86264038 * Math.pow(v,4) - 76.50784981 * Math.pow(v,3) + 3418.51312375 * Math.pow(v,2) - 1155.44340104 * v;
    vin1 = 173.90344176 * Math.pow(v,5) - 201.54790866 * Math.pow(v,4) - 365.67345333 * Math.pow(v,3) + 3388.92252588 * Math.pow(v,2) - 1157.29229832 * v;
    set2 = 236.62002924 * Math.pow(s,5) - 410.86264038 * Math.pow(s,4) - 76.50784981 * Math.pow(s,3) + 3418.51312375 * Math.pow(s,2) - 1155.44340104 * s;
    set1 = 173.90344176 * Math.pow(s,5) - 201.54790866 * Math.pow(s,4) - 365.67345333 * Math.pow(s,3) + 3388.92252588 * Math.pow(s,2) - 1157.29229832 * s;
    NT2 = 11749;
    NT1 = 10656;
  } else if (b < 13000) {
    vin2 = 313.40197726 * Math.pow(v,5) - 664.23842001 * Math.pow(v,4) + 266.16111612 * Math.pow(v,3) + 3443.95531559 * Math.pow(v,2) - 1153.17208749 * v;
    vin1 = 236.62002924 * Math.pow(v,5) - 410.86264038 * Math.pow(v,4) - 76.50784981 * Math.pow(v,3) + 3418.51312375 * Math.pow(v,2) - 1155.44340104 * v;
    set2 = 313.40197726 * Math.pow(s,5) - 664.23842001 * Math.pow(s,4) + 266.16111612 * Math.pow(s,3) + 3443.95531559 * Math.pow(s,2) - 1153.17208749 * s;
    set1 = 236.62002924 * Math.pow(s,5) - 410.86264038 * Math.pow(s,4) - 76.50784981 * Math.pow(s,3) + 3418.51312375 * Math.pow(s,2) - 1155.44340104 * s;
    NT2 = 13000;
    NT1 = 11749;
  } else if (b < 14445) {
    vin2 = 433.371812 * Math.pow(v,5) - 1099.97423053 * Math.pow(v,4) + 902.83521748 * Math.pow(v,3) + 3291.13158083 * Math.pow(v,2) - 1105.07625312 * v;
    vin1 = 313.40197726 * Math.pow(v,5) - 664.23842001 * Math.pow(v,4) + 266.16111612 * Math.pow(v,3) + 3443.95531559 * Math.pow(v,2) - 1153.17208749 * v;
    set2 = 433.371812 * Math.pow(s,5) - 1099.97423053 * Math.pow(s,4) + 902.83521748 * Math.pow(s,3) + 3291.13158083 * Math.pow(s,2) - 1105.07625312 * s;
    set1 = 313.40197726 * Math.pow(s,5) - 664.23842001 * Math.pow(s,4) + 266.16111612 * Math.pow(s,3) + 3443.95531559 * Math.pow(s,2) - 1153.17208749 * s;
    NT2 = 14445;
    NT1 = 13000;
  } else if (b < 15884) {
    vin2 = 565.22628537 * Math.pow(v,5) - 1585.90603364 * Math.pow(v,4) + 1616.81018543 * Math.pow(v,3) + 3079.7496165 * Math.pow(v,2) - 1041.18123722 * v;
    vin1 = 433.371812 * Math.pow(v,5) - 1099.97423053 * Math.pow(v,4) + 902.83521748 * Math.pow(v,3) + 3291.13158083 * Math.pow(v,2) - 1105.07625312 * v;
    set2 = 565.22628537 * Math.pow(s,5) - 1585.90603364 * Math.pow(s,4) + 1616.81018543 * Math.pow(s,3) + 3079.7496165 * Math.pow(s,2) - 1041.18123722 * s;
    set1 = 433.371812 * Math.pow(s,5) - 1099.97423053 * Math.pow(s,4) + 902.83521748 * Math.pow(s,3) + 3291.13158083 * Math.pow(s,2) - 1105.07625312 * s;
    NT2 = 15884;
    NT1 = 14445;
  } else if (b < 18728) {
    vin2 = 1498.67279 * Math.pow(v,5) - 5507.72242 * Math.pow(v,4) + 7902.01918 * Math.pow(v,3) - 1037.18569 * Math.pow(v,2) - 86.30835 * v;
    vin1 = 565.22628537 * Math.pow(v,5) - 1585.90603364 * Math.pow(v,4) + 1616.81018543 * Math.pow(v,3) + 3079.7496165 * Math.pow(v,2) - 1041.18123722 * v;
    set2 = 1498.67279 * Math.pow(s,5) - 5507.72242 * Math.pow(s,4) + 7902.01918 * Math.pow(s,3) - 1037.18569 * Math.pow(s,2) - 86.30835 * s;
    set1 = 565.22628537 * Math.pow(s,5) - 1585.90603364 * Math.pow(s,4) + 1616.81018543 * Math.pow(s,3) + 3079.7496165 * Math.pow(s,2) - 1041.18123722 * s;
    NT2 = 18728;
    NT1 = 15884;
  } else if (b < 20943) {
    vin2 = 2020.03382722 * Math.pow(v,5) - 7672.9804765 * Math.pow(v,4) + 11294.34790492 * Math.pow(v,3) - 3018.82055402 * Math.pow(v,2) + 395.50307876 * v;
    vin1 = 1498.67279 * Math.pow(v,5) - 5507.72242 * Math.pow(v,4) + 7902.01918 * Math.pow(v,3) - 1037.18569 * Math.pow(v,2) - 86.30835 * v;
    set2 = 2020.03382722 * Math.pow(s,5) - 7672.9804765 * Math.pow(s,4) + 11294.34790492 * Math.pow(s,3) - 3018.82055402 * Math.pow(s,2) + 395.50307876 * s;
    set1 = 1498.67279 * Math.pow(s,5) - 5507.72242 * Math.pow(s,4) + 7902.01918 * Math.pow(s,3) - 1037.18569 * Math.pow(s,2) - 86.30835 * s;
    NT2 = 20943;
    NT1 = 18728;
  } else if (b < 23674) {
    vin2 = 90808.30098438 * Math.pow(v,5) - 178372.97923088 * Math.pow(v,4) + 134421.30867577 * Math.pow(v,3) - 25604.69337463 * Math.pow(v,2) + 2422.42866802 * v;
    vin1 = 2020.03382722 * Math.pow(v,5) - 7672.9804765 * Math.pow(v,4) + 11294.34790492 * Math.pow(v,3) - 3018.82055402 * Math.pow(v,2) + 395.50307876 * v;
    set2 = 90808.30098438 * Math.pow(s,5) - 178372.97923088 * Math.pow(s,4) + 134421.30867577 * Math.pow(s,3) - 25604.69337463 * Math.pow(s,2) + 2422.42866802 * s;
    set1 = 2020.03382722 * Math.pow(s,5) - 7672.9804765 * Math.pow(s,4) + 11294.34790492 * Math.pow(s,3) - 3018.82055402 * Math.pow(s,2) + 395.50307876 * s;
    NT2 = 23674;
    NT1 = 20943;
  }
  
  dr1 = linterp(vin1,vin2,NT1,NT2,b);
  dr2 = linterp(set1,set2,NT1,NT2,b);

  dr = dr2 - dr1;
  return dr;
}

function RDD(z, t, rs, w) {// Finds distance traveled up to engine failure. uses Velocity During Takeoff BEO
  // the input speed needs to be adjusted for w
  var rs2 = rs;
  var rs2 = rs2 - w;
  
  // find the two guideslines to interpolate between
  var GRD1 = 0.000003513905 * Math.pow(t,4) - 0.000708033124 * Math.pow(t,3) + 0.294130990555 * Math.pow(t,2) - 1.892912089745 * t;
  var GRD2 = 0.000011226151 * Math.pow(t,4) - 0.003104399026 * Math.pow(t,3) + 0.464938794735 * Math.pow(t,2) - 7.530705053214 * t;
  var GRD3 = 0.000005249426 * Math.pow(t,4) - 0.00134507761 * Math.pow(t,3) + 0.273630954536 * Math.pow(t,2) - 3.579713385559 * t;
  var GRD4 = 0.000003139945 * Math.pow(t,4) - 0.0008795172 * Math.pow(t,3) + 0.216810740448 * Math.pow(t,2) - 3.009328481741 * t;
  var GRD5 = 0.000000495158 * Math.pow(t,4) - 0.000014723875 * Math.pow(t,3) + 0.098981038297 * Math.pow(t,2) + 0.445409534466 * t - 10.007056332394;
  var GRD6 = 0.000000515684 * Math.pow(t,4) - 0.000112485344 * Math.pow(t,3) + 0.09658259448 * Math.pow(t,2) - 0.650017446329 * t + 0.5299495412;
  var GRD7 = 0.000000523946 * Math.pow(t,4) - 0.000166434536 * Math.pow(t,3) + 0.087305009565 * Math.pow(t,2) - 0.961789399117 * t - 6.917025485388;
  
  var N2 = 0.000003513905 * Math.pow(rs2,4) - 0.000708033124 * Math.pow(rs2,3) + 0.294130990555 * Math.pow(rs2,2) - 1.892912089745 * rs2;
  var N1 = 0.000011226151 * Math.pow(rs2,4) - 0.003104399026 * Math.pow(rs2,3) + 0.464938794735 * Math.pow(rs2,2) - 7.530705053214 * rs2;
  var NT2 = GRD1;
  var NT1 = GRD2;
  if (z < GRD2) {
    N2 = 0.000011226151 * Math.pow(rs2,4) - 0.003104399026 * Math.pow(rs2,3) + 0.464938794735 * Math.pow(rs2,2) - 7.530705053214 * rs2;
    N1 = 0.000005249426 * Math.pow(rs2,4) - 0.00134507761 * Math.pow(rs2,3) + 0.273630954536 * Math.pow(rs2,2) - 3.579713385559 * rs2;
    NT2 = GRD2;
    NT1 = GRD3;
  }
  if (z < GRD3) {
    N2 = 0.000005249426 * Math.pow(rs2,4) - 0.00134507761 * Math.pow(rs2,3) + 0.273630954536 * Math.pow(rs2,2) - 3.579713385559 * rs2;
    N1 = 0.000003139945 * Math.pow(rs2,4) - 0.0008795172 * Math.pow(rs2,3) + 0.216810740448 * Math.pow(rs2,2) - 3.009328481741 * rs2;
    NT2 = GRD3;
    NT1 = GRD4;
  }
  if (z < GRD4) {
    N2 = 0.000003139945 * Math.pow(rs2,4) - 0.0008795172 * Math.pow(rs2,3) + 0.216810740448 * Math.pow(rs2,2) - 3.009328481741 * rs2;
    N1 = 0.000000495158 * Math.pow(rs2,4) - 0.000014723875 * Math.pow(rs2,3) + 0.098981038297 * Math.pow(rs2,2) + 0.445409534466 * rs2 - 10.007056332394;
    NT2 = GRD4;
    NT1 = GRD5;
  }
  if (z < GRD5) {
    N2 = 0.000000495158 * Math.pow(rs2,4) - 0.000014723875 * Math.pow(rs2,3) + 0.098981038297 * Math.pow(rs2,2) + 0.445409534466 * rs2 - 10.007056332394;
    N1 = 0.000000515684 * Math.pow(rs2,4) - 0.000112485344 * Math.pow(rs2,3) + 0.09658259448 * Math.pow(rs2,2) - 0.650017446329 * rs2 + 0.5299495412;
    NT2 = GRD5;
    NT1 = GRD6;
  }
  if (z < GRD6) {
    N2 = 0.000000515684 * Math.pow(rs2,4) - 0.000112485344 * Math.pow(rs2,3) + 0.09658259448 * Math.pow(rs2,2) - 0.650017446329 * rs2 + 0.5299495412;
    N1 = 0.000000523946 * Math.pow(rs2,4) - 0.000166434536 * Math.pow(rs2,3) + 0.087305009565 * Math.pow(rs2,2) - 0.961789399117 * rs2 - 6.917025485388;
    NT2 = GRD6;
    NT1 = GRD7;
  }
  
  //RDD = N1 + ((N2 - N1) / (NT2 - NT1)) * (z - NT1);
  r = linterp(N1,N2,NT1,NT2,z);
  return r;
}

function EORV(v, b, r) { // End of runway Velocity. Uses Velocity During Takeoff SEO
  var vn = v / 100;
  
  // r = remaining Runway
  // v = engine failure velocity
  // first find the two guideslines to interpolate between
  var Vguide = 150 / 100; //Finds the distanace at V = 150
  // We are finding the distance at V=150 because for a case such that the initial velocity is 0..
  // .. we would have division by 0 when we interpolate velocities
  
  // JPeters: C7 and H7 are never defined in the spreadsheet code; the following calculations get overwritten anyway.  Setting C7 and H7 to 1 so Javascript won't throw an error on the calculations below.
  var C7 = 1;
  var H7 = 1;
  
  var N2 = 4020.11436254 * Math.pow(vn,5) - 16206.06759548 * Math.pow(vn,4) + 24807.3251466799 * Math.pow(vn,3) - 11400.4034152 * Math.pow(vn,2) + 2399.52785391 * vn;
  var N1 = 90808.30098438 * Math.pow(vn,5) - 178372.97923088 * Math.pow(vn,4) + 134421.30867577 * Math.pow(vn,3) - 25604.69337463 * Math.pow(vn,2) + 2422.42866802 * vn;
  var NG2 = 4020.11436254 * Math.pow(Vguide,5) - 16206.06759548 * Math.pow(C7,4) + 24807.3251466799 * Math.pow(C7,3) - 11400.4034152 * Math.pow(C7,2) + 2399.52785391 * C7;
  var NG1 = 90808.30098438 * Math.pow(H7,5) - 178372.97923088 * Math.pow(H7,4) + 134421.30867577 * Math.pow(H7,3) - 25604.69337463 * Math.pow(H7,2) + 2422.42866802 * H7;
  var NT2 = 27002;
  var NT1 = 23674;
  var Guide = 1;
  if (b < 9590) {
    N2 = 714.37893814 * Math.pow(vn,3) + 1012.30599624 * Math.pow(vn,2) - 87.11530206 * vn;
    N1 = 534.14088343 * Math.pow(vn,3) + 1014.39681758 * Math.pow(vn,2) - 129.34359137 * vn;
    NG2 = 714.37893814 * Math.pow(Vguide,3) + 1012.30599624 * Math.pow(Vguide,2) - 87.11530206 * Vguide;
    NG1 = 534.14088343 * Math.pow(Vguide,3) + 1014.39681758 * Math.pow(Vguide,2) - 129.34359137 * Vguide;
    NT2 = 9590;
    NT1 = 8072;
    Guide = 10;
  } else if (b < 10656) {
    N2 = 173.90344176 * Math.pow(vn,5) - 201.54790866 * Math.pow(vn,4) - 365.67345333 * Math.pow(vn,3) + 3388.92252588 * Math.pow(vn,2) - 1157.29229832 * vn;
    N1 = 714.37893814 * Math.pow(vn,3) + 1012.30599624 * Math.pow(vn,2) - 87.11530206 * vn;
    NG2 = 173.90344176 * Math.pow(Vguide,5) - 201.54790866 * Math.pow(Vguide,4) - 365.67345333 * Math.pow(Vguide,3) + 3388.92252588 * Math.pow(Vguide,2) - 1157.29229832 * Vguide;
    NG1 = 714.37893814 * Math.pow(Vguide,3) + 1012.30599624 * Math.pow(Vguide,2) - 87.11530206 * Vguide;
    NT2 = 10656;
    NT1 = 9590;
    Guide = 9;
  } else if (b < 11749) {
    N2 = 236.62002924 * Math.pow(vn,5) - 410.86264038 * Math.pow(vn,4) - 76.50784981 * Math.pow(vn,3) + 3418.51312375 * Math.pow(vn,2) - 1155.44340104 * vn;
    N1 = 173.90344176 * Math.pow(vn,5) - 201.54790866 * Math.pow(vn,4) - 365.67345333 * Math.pow(vn,3) + 3388.92252588 * Math.pow(vn,2) - 1157.29229832 * vn;
    NG2 = 236.62002924 * Math.pow(Vguide,5) - 410.86264038 * Math.pow(Vguide,4) - 76.50784981 * Math.pow(Vguide,3) + 3418.51312375 * Math.pow(Vguide,2) - 1155.44340104 * Vguide;
    NG1 = 173.90344176 * Math.pow(Vguide,5) - 201.54790866 * Math.pow(Vguide,4) - 365.67345333 * Math.pow(Vguide,3) + 3388.92252588 * Math.pow(Vguide,2) - 1157.29229832 * Vguide;
    NT2 = 11749;
    NT1 = 10656;
    Guide = 8;
  } else if (b < 13000) {
    N2 = 313.40197726 * Math.pow(vn,5) - 664.23842001 * Math.pow(vn,4) + 266.16111612 * Math.pow(vn,3) + 3443.95531559 * Math.pow(vn,2) - 1153.17208749 * vn;
    N1 = 236.62002924 * Math.pow(vn,5) - 410.86264038 * Math.pow(vn,4) - 76.50784981 * Math.pow(vn,3) + 3418.51312375 * Math.pow(vn,2) - 1155.44340104 * vn;
    NG2 = 313.40197726 * Math.pow(Vguide,5) - 664.23842001 * Math.pow(Vguide,4) + 266.16111612 * Math.pow(Vguide,3) + 3443.95531559 * Math.pow(Vguide,2) - 1153.17208749 * Vguide;
    NG1 = 236.62002924 * Math.pow(Vguide,5) - 410.86264038 * Math.pow(Vguide,4) - 76.50784981 * Math.pow(Vguide,3) + 3418.51312375 * Math.pow(Vguide,2) - 1155.44340104 * Vguide;
    NT2 = 13000;
    NT1 = 11749;
    Guide = 7;
  } else if (b < 14445) {
    N2 = 433.371812 * Math.pow(vn,5) - 1099.97423053 * Math.pow(vn,4) + 902.83521748 * Math.pow(vn,3) + 3291.13158083 * Math.pow(vn,2) - 1105.07625312 * vn;
    N1 = 313.40197726 * Math.pow(vn,5) - 664.23842001 * Math.pow(vn,4) + 266.16111612 * Math.pow(vn,3) + 3443.95531559 * Math.pow(vn,2) - 1153.17208749 * vn;
    NG2 = 433.371812 * Math.pow(Vguide,5) - 1099.97423053 * Math.pow(Vguide,4) + 902.83521748 * Math.pow(Vguide,3) + 3291.13158083 * Math.pow(Vguide,2) - 1105.07625312 * Vguide;
    NG1 = 313.40197726 * Math.pow(Vguide,5) - 664.23842001 * Math.pow(Vguide,4) + 266.16111612 * Math.pow(Vguide,3) + 3443.95531559 * Math.pow(Vguide,2) - 1153.17208749 * Vguide;
    NT2 = 14445;
    NT1 = 13000;
    Guide = 6;
  } else if (b < 15884) {
    N2 = 565.22628537 * Math.pow(vn,5) - 1585.90603364 * Math.pow(vn,4) + 1616.81018543 * Math.pow(vn,3) + 3079.7496165 * Math.pow(vn,2) - 1041.18123722 * vn;
    N1 = 433.371812 * Math.pow(vn,5) - 1099.97423053 * Math.pow(vn,4) + 902.83521748 * Math.pow(vn,3) + 3291.13158083 * Math.pow(vn,2) - 1105.07625312 * vn;
    NG2 = 565.22628537 * Math.pow(Vguide,5) - 1585.90603364 * Math.pow(Vguide,4) + 1616.81018543 * Math.pow(Vguide,3) + 3079.7496165 * Math.pow(Vguide,2) - 1041.18123722 * Vguide;
    NG1 = 433.371812 * Math.pow(Vguide,5) - 1099.97423053 * Math.pow(Vguide,4) + 902.83521748 * Math.pow(Vguide,3) + 3291.13158083 * Math.pow(Vguide,2) - 1105.07625312 * Vguide;
    NT2 = 15884;
    NT1 = 14445;
    Guide = 5;
  } else if (b < 18728) {
    N2 = 1498.67279 * Math.pow(vn,5) - 5507.72242 * Math.pow(vn,4) + 7902.01918 * Math.pow(vn,3) - 1037.18569 * Math.pow(vn,2) - 86.30835 * vn;
    N1 = 565.22628537 * Math.pow(vn,5) - 1585.90603364 * Math.pow(vn,4) + 1616.81018543 * Math.pow(vn,3) + 3079.7496165 * Math.pow(vn,2) - 1041.18123722 * vn;
    NG2 = 1498.67279 * Math.pow(Vguide,5) - 5507.72242 * Math.pow(Vguide,4) + 7902.01918 * Math.pow(Vguide,3) - 1037.18569 * Math.pow(Vguide,2) - 86.30835 * Vguide;
    NG1 = 565.22628537 * Math.pow(Vguide,5) - 1585.90603364 * Math.pow(Vguide,4) + 1616.81018543 * Math.pow(Vguide,3) + 3079.7496165 * Math.pow(Vguide,2) - 1041.18123722 * Vguide;
    NT2 = 18728;
    NT1 = 15884;
    Guide = 4;
  } else if (b < 20943) {
    N2 = 2020.03382722 * Math.pow(vn,5) - 7672.9804765 * Math.pow(vn,4) + 11294.34790492 * Math.pow(vn,3) - 3018.82055402 * Math.pow(vn,2) + 395.50307876 * vn;
    N1 = 1498.67279 * Math.pow(vn,5) - 5507.72242 * Math.pow(vn,4) + 7902.01918 * Math.pow(vn,3) - 1037.18569 * Math.pow(vn,2) - 86.30835 * vn;
    NG2 = 2020.03382722 * Math.pow(Vguide,5) - 7672.9804765 * Math.pow(Vguide,4) + 11294.34790492 * Math.pow(Vguide,3) - 3018.82055402 * Math.pow(Vguide,2) + 395.50307876 * Vguide;
    NG1 = 1498.67279 * Math.pow(Vguide,5) - 5507.72242 * Math.pow(Vguide,4) + 7902.01918 * Math.pow(Vguide,3) - 1037.18569 * Math.pow(Vguide,2) - 86.30835 * Vguide;
    NT2 = 20943;
    NT1 = 18728;
    Guide = 3;
  } else if (b < 23674) {
    N2 = 90808.30098438 * Math.pow(vn,5) - 178372.97923088 * Math.pow(vn,4) + 134421.30867577 * Math.pow(vn,3) - 25604.69337463 * Math.pow(vn,2) + 2422.42866802 * vn;
    N1 = 2020.03382722 * Math.pow(vn,5) - 7672.9804765 * Math.pow(vn,4) + 11294.34790492 * Math.pow(vn,3) - 3018.82055402 * Math.pow(vn,2) + 395.50307876 * vn;
    NG2 = 90808.30098438 * Math.pow(Vguide,5) - 178372.97923088 * Math.pow(Vguide,4) + 134421.30867577 * Math.pow(Vguide,3) - 25604.69337463 * Math.pow(Vguide,2) + 2422.42866802 * Vguide;
    NG1 = 2020.03382722 * Math.pow(Vguide,5) - 7672.9804765 * Math.pow(Vguide,4) + 11294.34790492 * Math.pow(Vguide,3) - 3018.82055402 * Math.pow(Vguide,2) + 395.50307876 * Vguide;
    NT2 = 23674;
    NT1 = 20943;
    Guide = 2;
  }
  
  distance1 = N1 + ((N2 - N1) / (NT2 - NT1)) * (b - NT1);
  Distance2 = distance1 + r;
  GuideDist = NG1 + ((NG2 - NG1) / (NT2 - NT1)) * (b - NT1); // Distance at V=150
  
  distance1 = distance1 / 10000;
  Distance2 = Distance2 / 10000;
  GuideDist = GuideDist / 10000;
  
  // Now find the Velocity at distance2 using Velocity During takeoff Ground run
  switch(Guide) {
    case 1:
      N2 = 5.2252 * Math.pow(Distance2,5) - 42.2822 * Math.pow(Distance2,4) + 133.5299 * Math.pow(Distance2,3) - 218.6953 * Math.pow(Distance2,2) + 231.1848 * Distance2 + 39.6474;
      N1 = 9.1495 * Math.pow(Distance2,5) - 65.2083 * Math.pow(Distance2,4) + 181.706 * Math.pow(Distance2,3) - 263.8596 * Math.pow(Distance2,2) + 251.8279 * Distance2 + 40.102;
      NT2 = 5.2252 * Math.pow(GuideDist,5) - 42.2822 * Math.pow(GuideDist,4) + 133.5299 * Math.pow(GuideDist,3) - 218.6953 * Math.pow(GuideDist,2) + 231.1848 * GuideDist + 39.6474;
      NT1 = 9.1495 * Math.pow(GuideDist,5) - 65.2083 * Math.pow(GuideDist,4) + 181.706 * Math.pow(GuideDist,3) - 263.8596 * Math.pow(GuideDist,2) + 251.8279 * GuideDist + 40.102;
      break;
    case 2:
      N2 = 9.1495 * Math.pow(Distance2,5) - 65.2083 * Math.pow(Distance2,4) + 181.706 * Math.pow(Distance2,3) - 263.8596 * Math.pow(Distance2,2) + 251.8279 * Distance2 + 40.102;
      N1 = 15.6871 * Math.pow(Distance2,5) - 98.9123 * Math.pow(Distance2,4) + 244.3219 * Math.pow(Distance2,3) - 316.0179 * Math.pow(Distance2,2) + 273.4009 * Distance2 + 40.603;
      NT2 = 9.1495 * Math.pow(GuideDist,5) - 65.2083 * Math.pow(GuideDist,4) + 181.706 * Math.pow(GuideDist,3) - 263.8596 * Math.pow(GuideDist,2) + 251.8279 * GuideDist + 40.102;
      NT1 = 15.6871 * Math.pow(GuideDist,5) - 98.9123 * Math.pow(GuideDist,4) + 244.3219 * Math.pow(GuideDist,3) - 316.0179 * Math.pow(GuideDist,2) + 273.4009 * GuideDist + 40.603;
      break;
    case 3:
      N2 = 15.6871 * Math.pow(Distance2,5) - 98.9123 * Math.pow(Distance2,4) + 244.3219 * Math.pow(Distance2,3) - 316.0179 * Math.pow(Distance2,2) + 273.4009 * Distance2 + 40.603;
      N1 = 25.1895 * Math.pow(Distance2,5) - 142.6305 * Math.pow(Distance2,4) + 317.0274 * Math.pow(Distance2,3) - 370.7184 * Math.pow(Distance2,2) + 294.4331 * Distance2 + 41.1908;
      NT2 = 15.6871 * Math.pow(GuideDist,5) - 98.9123 * Math.pow(GuideDist,4) + 244.3219 * Math.pow(GuideDist,3) - 316.0179 * Math.pow(GuideDist,2) + 273.4009 * GuideDist + 40.603;
      NT1 = 25.1895 * Math.pow(GuideDist,5) - 142.6305 * Math.pow(GuideDist,4) + 317.0274 * Math.pow(GuideDist,3) - 370.7184 * Math.pow(GuideDist,2) + 294.4331 * GuideDist + 41.1908;
      break;
    case 4:
      N2 = 25.1895 * Math.pow(Distance2,5) - 142.6305 * Math.pow(Distance2,4) + 317.0274 * Math.pow(Distance2,3) - 370.7184 * Math.pow(Distance2,2) + 294.4331 * Distance2 + 41.1908;
      N1 = 48.8616 * Math.pow(Distance2,5) - 235.3158 * Math.pow(Distance2,4) + 445.9163 * Math.pow(Distance2,3) - 447.9319 * Math.pow(Distance2,2) + 319.4103 * Distance2 + 40.1379;
      NT2 = 25.1895 * Math.pow(GuideDist,5) - 142.6305 * Math.pow(GuideDist,4) + 317.0274 * Math.pow(GuideDist,3) - 370.7184 * Math.pow(GuideDist,2) + 294.4331 * GuideDist + 41.1908;
      NT1 = 48.8616 * Math.pow(GuideDist,5) - 235.3158 * Math.pow(GuideDist,4) + 445.9163 * Math.pow(GuideDist,3) - 447.9319 * Math.pow(GuideDist,2) + 319.4103 * GuideDist + 40.1379;
      break;
    case 5:
      N2 = 48.8616 * Math.pow(Distance2,5) - 235.3158 * Math.pow(Distance2,4) + 445.9163 * Math.pow(Distance2,3) - 447.9319 * Math.pow(Distance2,2) + 319.4103 * Distance2 + 40.1379;
      N1 = 73.6437 * Math.pow(Distance2,5) - 323.3521 * Math.pow(Distance2,4) + 559.7907 * Math.pow(Distance2,3) - 515.8792 * Math.pow(Distance2,2) + 341.6309 * Distance2 + 40.8589;
      NT2 = 48.8616 * Math.pow(GuideDist,5) - 235.3158 * Math.pow(GuideDist,4) + 445.9163 * Math.pow(GuideDist,3) - 447.9319 * Math.pow(GuideDist,2) + 319.4103 * GuideDist + 40.1379;
      NT1 = 73.6437 * Math.pow(GuideDist,5) - 323.3521 * Math.pow(GuideDist,4) + 559.7907 * Math.pow(GuideDist,3) - 515.8792 * Math.pow(GuideDist,2) + 341.6309 * GuideDist + 40.8589;
      break;
    case 6:
      N2 = 73.6437 * Math.pow(Distance2,5) - 323.3521 * Math.pow(Distance2,4) + 559.7907 * Math.pow(Distance2,3) - 515.8792 * Math.pow(Distance2,2) + 341.6309 * Distance2 + 40.8589;
      N1 = 114.9031 * Math.pow(Distance2,5) - 456.1144 * Math.pow(Distance2,4) + 715.8557 * Math.pow(Distance2,3) - 601.1502 * Math.pow(Distance2,2) + 367.7768 * Distance2 + 41.6646;
      NT2 = 73.6437 * Math.pow(GuideDist,5) - 323.3521 * Math.pow(GuideDist,4) + 559.7907 * Math.pow(GuideDist,3) - 515.8792 * Math.pow(GuideDist,2) + 341.6309 * GuideDist + 40.8589;
      NT1 = 114.9031 * Math.pow(GuideDist,5) - 456.1144 * Math.pow(GuideDist,4) + 715.8557 * Math.pow(GuideDist,3) - 601.1502 * Math.pow(GuideDist,2) + 367.7768 * GuideDist + 41.6646;
      break;
    case 7:
      N2 = 114.9031 * Math.pow(Distance2,5) - 456.1144 * Math.pow(Distance2,4) + 715.8557 * Math.pow(Distance2,3) - 601.1502 * Math.pow(Distance2,2) + 367.7768 * Distance2 + 41.6646;
      N1 = 172.609 * Math.pow(Distance2,5) - 625.6121 * Math.pow(Distance2,4) + 898.4069 * Math.pow(Distance2,3) - 693.2961 * Math.pow(Distance2,2) + 394.4457 * Distance2 + 42.5179;
      NT2 = 114.9031 * Math.pow(GuideDist,5) - 456.1144 * Math.pow(GuideDist,4) + 715.8557 * Math.pow(GuideDist,3) - 601.1502 * Math.pow(GuideDist,2) + 367.7768 * GuideDist + 41.6646;
      NT1 = 172.609 * Math.pow(GuideDist,5) - 625.6121 * Math.pow(GuideDist,4) + 898.4069 * Math.pow(GuideDist,3) - 693.2961 * Math.pow(GuideDist,2) + 394.4457 * GuideDist + 42.5179;
      break;
    case 8:
      N2 = 172.609 * Math.pow(Distance2,5) - 625.6121 * Math.pow(Distance2,4) + 898.4069 * Math.pow(Distance2,3) - 693.2961 * Math.pow(Distance2,2) + 394.4457 * Distance2 + 42.5179;
      N1 = 261.4916 * Math.pow(Distance2,5) - 862.2106 * Math.pow(Distance2,4) + 1129.6203 * Math.pow(Distance2,3) - 799.4395 * Math.pow(Distance2,2) + 422.6261 * Distance2 + 43.3745;
      NT2 = 172.609 * Math.pow(GuideDist,5) - 625.6121 * Math.pow(GuideDist,4) + 898.4069 * Math.pow(GuideDist,3) - 693.2961 * Math.pow(GuideDist,2) + 394.4457 * GuideDist + 42.5179;
      NT1 = 261.4916 * Math.pow(GuideDist,5) - 862.2106 * Math.pow(GuideDist,4) + 1129.6203 * Math.pow(GuideDist,3) - 799.4395 * Math.pow(GuideDist,2) + 422.6261 * GuideDist + 43.3745;
      break;
    case 9:
      N2 = 261.4916 * Math.pow(Distance2,5) - 862.2106 * Math.pow(Distance2,4) + 1129.6203 * Math.pow(Distance2,3) - 799.4395 * Math.pow(Distance2,2) + 422.6261 * Distance2 + 43.3745;
      N1 = 383.8511 * Math.pow(Distance2,5) - 1160.1817 * Math.pow(Distance2,4) + 1397.0436 * Math.pow(Distance2,3) - 913.2236 * Math.pow(Distance2,2) + 451.2853 * Distance2 + 44.2771;
      NT2 = 261.4916 * Math.pow(GuideDist,5) - 862.2106 * Math.pow(GuideDist,4) + 1129.6203 * Math.pow(GuideDist,3) - 799.4395 * Math.pow(GuideDist,2) + 422.6261 * GuideDist + 43.3745;
      NT1 = 383.8511 * Math.pow(GuideDist,5) - 1160.1817 * Math.pow(GuideDist,4) + 1397.0436 * Math.pow(GuideDist,3) - 913.2236 * Math.pow(GuideDist,2) + 451.2853 * GuideDist + 44.2771;
      break;
    case 10:
      N2 = 383.8511 * Math.pow(Distance2,5) - 1160.1817 * Math.pow(Distance2,4) + 1397.0436 * Math.pow(Distance2,3) - 913.2236 * Math.pow(Distance2,2) + 451.2853 * Distance2 + 44.2771;
      N1 = 848.336 * Math.pow(Distance2,5) - 2166.8795 * Math.pow(Distance2,4) + 2211.6391 * Math.pow(Distance2,3) - 1230.8856 * Math.pow(Distance2,2) + 524.5816 * Distance2 + 44.0779;
      NT2 = 383.8511 * Math.pow(GuideDist,5) - 1160.1817 * Math.pow(GuideDist,4) + 1397.0436 * Math.pow(GuideDist,3) - 913.2236 * Math.pow(GuideDist,2) + 451.2853 * GuideDist + 44.2771;
      NT1 = 848.336 * Math.pow(GuideDist,5) - 2166.8795 * Math.pow(GuideDist,4) + 2211.6391 * Math.pow(GuideDist,3) - 1230.8856 * Math.pow(GuideDist,2) + 524.5816 * GuideDist + 44.0779;
      break;
  }
  
  var e = N1 + ((N2 - N1) / (NT2 - NT1)) * (Vguide * 100 - NT1);
  return e;
}



function calcHeadwind(){
  var hw = windVelocity * (Math.cos((runwayHeading - windDirection) * Math.PI/180));
  return hw;
}

function calcCrosswind(){
  var cw = Math.abs(windVelocity * (Math.sin((runwayHeading - windDirection) * Math.PI/180)));
  return cw.toFixed(0);
}

function calcMACS(){
  var macs = 'NI';
  return macs;
}

function calcMACSDistance(){
  var macsd = 'NI';
  return macsd;
}

function calcDS(){
  var ds = 'NI';
  return ds;
}

function calcRSEF(){
  var rsef = 'NI';
  return rsef;
}

function calcSETOS(){
  var setos = 'NI';
  return setos;
}

function calcSAEOR(){
  var saeor = 'NI';
  return saeor;
}

function calcGearDNSECG(){
  var gdnsecg = 'NI';
  return gdnsecg;
}

function calcGearUPSECG(){
  var gupsecg = 'NI';
  return gupsecg;
}

function calcCFL(){
  var cfl = 'NI';
  return cfl;
}

function calcNACS(){
  var nacs = 'NI';
  return nacs;
}

function calcRSBEO(){
  var rsbeo = 'NI';
  return rsbeo;
}

function calcRotationSpeed(){
  var rs = 'NI';
  return rs;
}

function calcTakeoffSpeed(){
  var tos = 'NI';
  return tos;
}

function calcTakeoffDistance(){
  var tod = 'NI';
  return tod;
}

function calcCEFS(){
  var cefs = 'NI';
  return cefs;
}

function calcEFSAEOR(){
  var efsaeor = 'NI';
  return efsaeor;
}

function calcEFGearDNSECG(){
  var efgdnsecg = 'NI';
  return efgdnsecg;
}

function calcEFGearUPSECG(){
  var efgupsecg = 'NI';
  return efgupsecg;
}


$(document).ready(function(){
  aerobrake        = $.getUrlVar('radAeroBraking');
  temperature      = $.getUrlVar('temperature');
  temperatureScale = $.getUrlVar('temperatureScale');
  pressureAlt      = $.getUrlVar('pressureAlt');
  runwayLength     = $.getUrlVar('runwayLength');
  runwayHeading    = $.getUrlVar('runwayHeading');
  windDirection    = $.getUrlVar('windDirection');
  windVelocity     = $.getUrlVar('windVelocity');
  runwaySlope      = $.getUrlVar('runwaySlope');
  rcr              = $.getUrlVar('rcr');
  // acGrossWt        = $.getUrlVar('acGrossWt');
  acGrossWt        = $.getUrlVar('wtUsedForTOLD');
  // podWtPlusCargo   = $.getUrlVar('podWtPlusCargo');
  givenEngFailAt   = $.getUrlVar('givenEngFailAt');
  podMounted       = $.getUrlVar('podMounted');
  if (podMounted == undefined) {
    podMounted = 0;
  }
  runwayLength = runwayLength * 1.0;
    
  // Make sure temperature is expressed in Celsius
  if (temperatureScale == 'F') temperature = TF2C(temperature);
  // Calculate temperature in Kelvin
  temperatureK = TC2K(temperature);
  
  // If pod is mounted, add its weight to the aircraft gross weight
  /* This is now done on the front-end
  if (podMounted != 0) {
    acGrossWt = acGrossWt * 1.0 + 110;
  }
  */
  
  // Subtract 360lbs from gross weight for fuel burned during taxi run. *OBE due to changes in input form.*
  // acGrossWt = acGrossWt - 360;
  
  // For some reason, the spreadsheet model always has WSSPin (podMounted) set to 0.
  // Corrected in spreadsheet model v4.2
  // podMounted = 0;
      
  var Headwind        = calcHeadwind();
  var Crosswind       = calcCrosswind(); 
  
  // Establish altitude, weight, runway length, and temperature bounds 
  // for RS, TOS, 50ftSpeed, SETOS, SECG, CFL, CEFS, 50ftDistance, 
  // SEGrdBaseline, SpeedFor200FPNM, DS and SECG FPM calcs
  GeneralBounds = new Object();
  altitudeBins = [6,5,4,3,2,1,0];
  paIndex = pressureAlt/1000;
  paFloor = Math.floor(paIndex);
  
  aryPs = pickBounds(paIndex,altitudeBins);
  GeneralBounds.pressureAltLow = aryPs[0];
  GeneralBounds.pressureAltHigh = aryPs[1];
  
  weightBins = [14,13.5,13,12.8,12.5,12,11.5,11];
  weightIndex = acGrossWt/1000;
  aryWs = pickBounds(weightIndex,weightBins);
  GeneralBounds.weightLow = aryWs[0];
  GeneralBounds.weightHigh = aryWs[1];
  
  rlBins = [15000,13000,12000,11000,10000,9000,8500,8000,7000];
  aryRLs = pickBounds(runwayLength,rlBins);
  GeneralBounds.runwayLengthLow = aryRLs[0];
  GeneralBounds.runwayLengthHigh = aryRLs[1];
  
  temperatureBins = [50,45,40,35,30,25,20,15,10,5,0,-5,-10,-15,-20];
  aryTemperatures = pickBounds(temperature, temperatureBins);
  aryTemperatures[1] = aryTemperatures[0] + 5;
  GeneralBounds.temperatureLow = aryTemperatures[0];
  GeneralBounds.temperatureHigh = aryTemperatures[1];
  
  // Run calculations for RS, TOS, 50ftSpeed, SETOS, SECG, CFL, CEFS, 50ftDistance, SEGrdBaseline, SpeedFor200FPNM, DS and SECG FPM
  // (From Calc sheet)
  aryTemperatures = [];
  for (i = 0; i < 7; i = i + 2) {
    aryTemperatures[i] = GeneralBounds.temperatureLow;
    aryTemperatures[i+1] = GeneralBounds.temperatureHigh;
  }
  
  aryPressureAlts = [];
  for (i = 0; i < 4; i++) {
    aryPressureAlts[i] = GeneralBounds.pressureAltLow;
    aryPressureAlts[i+4] = GeneralBounds.pressureAltHigh;
  }
  
  aryWeights = [];
  for (i = 0; i < 5; i = i + 4) {
    aryWeights[i] = GeneralBounds.weightLow;
    aryWeights[i+1] = GeneralBounds.weightLow;
    aryWeights[i+2] = GeneralBounds.weightHigh;
    aryWeights[i+3] = GeneralBounds.weightHigh;
  }
   
  aryTemperaturesK = [];
  for (i = 0; i < 8; i++) {
    aryTemperaturesK[i] = TC2K(aryTemperatures[i]);
  }

  // Calculate TWAs for all Calc sheet computations
  aryTWAs = [];
  for (i = 0; i < 8; i++) {
    aryTWAs[i] = ((aryTemperaturesK[i] * Math.pow(10,6)) + (aryWeights[i] * 100) + (aryPressureAlts[i] * 1.0)).toFixed(0);
  }
      
  // Perform lookups of TWAs against TOData for RS
  aryRSBase = [];
  for (i = 0; i < 8; i++) {
    aryRSBase[i] = TOData[aryTWAs[i]][0];
  }

  // Interpolate with pressureAlt as the factor (4 results)  
  aryRSInterpByPressureAlt = []
  for (i=0;i < 4;i++) {
    aryRSInterpByPressureAlt[i] = linterp(aryRSBase[i], aryRSBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Interpolate with weight as the factor (2 results)
  aryRSInterpByWeight = [];
  for (i=0;i < 2;i++) {
    aryRSInterpByWeight[i] = linterp(aryRSInterpByPressureAlt[i], aryRSInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Interpolate with temperature (K) as the factor (1 result)
  RS = linterp(aryRSInterpByWeight[0], aryRSInterpByWeight[1], aryTemperaturesK[0], aryTemperatures[1], temperatureK);



  // Perform lookups of TWAs against TOData for TOS
  aryTOSBase = [];
  for (i=0;i < 8;i++) {
    aryTOSBase[i] = TOData[aryTWAs[i]][4];
  }

  // Interpolate with pressureAlt as the factor (4 results)  
  aryTOSInterpByPressureAlt = []
  for (i=0;i < 4;i++) {
    aryTOSInterpByPressureAlt[i] = linterp(aryTOSBase[i], aryTOSBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Interpolate with weight as the factor (2 results)
  aryTOSInterpByWeight = [];
  for (i=0;i < 2;i++) {
    aryTOSInterpByWeight[i] = linterp(aryTOSInterpByPressureAlt[i], aryTOSInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Interpolate with temperature (K) as the factor (1 result)
  TOS = linterp(aryTOSInterpByWeight[0], aryTOSInterpByWeight[1], aryTemperaturesK[0], aryTemperatures[1], temperatureK);



  // Perform lookups of TWAs against TOData for 50 Ft Obstacle Speed
  aryFFOSBase = [];
  for (i=0;i < 8;i++) {
    aryFFOSBase[i] = TOData[aryTWAs[i]][2];
  }

  // Interpolate with pressureAlt as the factor (4 results)  
  aryFFOSInterpByPressureAlt = []
  for (i=0;i < 4;i++) {
    aryFFOSInterpByPressureAlt[i] = linterp(aryFFOSBase[i], aryFFOSBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Interpolate with weight as the factor (2 results)
  aryFFOSInterpByWeight = [];
  for (i=0;i < 2;i++) {
    aryFFOSInterpByWeight[i] = linterp(aryFFOSInterpByPressureAlt[i], aryFFOSInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Interpolate with temperature (K) as the factor (1 result)
  FFOS = linterp(aryFFOSInterpByWeight[0], aryFFOSInterpByWeight[1], aryTemperaturesK[0], aryTemperatures[1], temperatureK);



  // Perform lookups of TWAs against TOData for SETOS
  arySETOSBase = [];
  for (i=0;i < 8;i++) {
    arySETOSBase[i] = TOData[aryTWAs[i]][5];
  }

  // Interpolate with pressureAlt as the factor (4 results)  
  arySETOSInterpByPressureAlt = []
  for (i=0;i < 4;i++) {
    arySETOSInterpByPressureAlt[i] = linterp(arySETOSBase[i], arySETOSBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Interpolate with weight as the factor (2 results)
  arySETOSInterpByWeight = [];
  for (i=0;i < 2;i++) {
    arySETOSInterpByWeight[i] = linterp(arySETOSInterpByPressureAlt[i], arySETOSInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Interpolate with temperature (K) as the factor (1 result)
  SETOS = linterp(arySETOSInterpByWeight[0], arySETOSInterpByWeight[1], aryTemperaturesK[0], aryTemperaturesK[1], temperatureK);

     

  // Perform lookups of TWAs against TOData for SECG
  arySECGBase = [];
  for (i=0;i < 8;i++) {
    arySECGBase[i] = TOData[aryTWAs[i]][6];
  }

  // Interpolate with pressureAlt as the factor (4 results)  
  arySECGInterpByPressureAlt = []
  for (i=0;i < 4;i++) {
    arySECGInterpByPressureAlt[i] = linterp(arySECGBase[i], arySECGBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Interpolate with weight as the factor (2 results)
  arySECGInterpByWeight = [];
  for (i=0;i < 2;i++) {
    arySECGInterpByWeight[i] = linterp(arySECGInterpByPressureAlt[i], arySECGInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Interpolate with temperature (K) as the factor (1 result)
  SECG = linterp(arySECGInterpByWeight[0], arySECGInterpByWeight[1], aryTemperaturesK[0], aryTemperaturesK[1], temperatureK);

  // Perform lookups of TWAs against TOData for TOD
  aryTODBase = [];
  for (i=0;i < 8;i++) {
    aryTODBase[i] = TOData[aryTWAs[i]][1];
  }

  // Interpolate with pressureAlt as the factor (4 results)  
  aryTODInterpByPressureAlt = []
  for (i=0;i < 4;i++) {
    aryTODInterpByPressureAlt[i] = linterp(aryTODBase[i], aryTODBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Interpolate with weight as the factor (2 results)
  aryTODInterpByWeight = [];
  for (i=0;i < 2;i++) {
    aryTODInterpByWeight[i] = linterp(aryTODInterpByPressureAlt[i], aryTODInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Interpolate with temperature (K) as the factor (1 result)
  TOD = linterp(aryTODInterpByWeight[0], aryTODInterpByWeight[1], aryTemperaturesK[0], aryTemperaturesK[1], temperatureK);



  // Perform lookups of TWAs against TOData for 50 Ft Distance
  aryFFDBase = [];
  for (i=0;i < 8;i++) {
    aryFFDBase[i] = TOData[aryTWAs[i]][3];
  }

  // Interpolate with pressureAlt as the factor (4 results)  
  aryFFDInterpByPressureAlt = []
  for (i=0;i < 4;i++) {
    aryFFDInterpByPressureAlt[i] = linterp(aryFFDBase[i], aryFFDBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Interpolate with weight as the factor (2 results)
  aryFFDInterpByWeight = [];
  for (i=0;i < 2;i++) {
    aryFFDInterpByWeight[i] = linterp(aryFFDInterpByPressureAlt[i], aryFFDInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Interpolate with temperature (K) as the factor (1 result)
  FFD = linterp(aryFFDInterpByWeight[0], aryFFDInterpByWeight[1], aryTemperaturesK[0], aryTemperatures[1], temperatureK);



  // Perform lookups of TWAs against TOData for SE Grd run baseline
  arySEGRBBase = [];
  for (i=0;i < 8;i++) {
    arySEGRBBase[i] = TOData[aryTWAs[i]][9];
  }

  // Interpolate with pressureAlt as the factor (4 results)  
  arySEGRBInterpByPressureAlt = []
  for (i=0;i < 4;i++) {
    arySEGRBInterpByPressureAlt[i] = linterp(arySEGRBBase[i], arySEGRBBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Interpolate with weight as the factor (2 results)
  arySEGRBInterpByWeight = [];
  for (i=0;i < 2;i++) {
    arySEGRBInterpByWeight[i] = linterp(arySEGRBInterpByPressureAlt[i], arySEGRBInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Interpolate with temperature (K) as the factor (1 result)
  SEGRB = linterp(arySEGRBInterpByWeight[0], arySEGRBInterpByWeight[1], aryTemperaturesK[0], aryTemperaturesK[1], temperatureK);


  
  // Establish altitude, weight, runway length, and temperature bounds for Decision Speed wind data  
  DSwindBounds = new Object();
  p = pressureAlt / 1000;
  if (p <= 6) DSwindBounds.pressureAltLow = 2;
  if (p < 2) DSwindBounds.pressureAltLow = 0;
  DSwindBounds.pressureAltHigh = DSwindBounds.pressureAltLow + 2;
  
  if (weightIndex <= 14) DSwindBounds.weightLow = 12.5;
  if (weightIndex < 12.5) DSwindBounds.weightLow = 11.5;
  DSwindBounds.weightHigh = DSwindBounds.weightLow + 1;
  
  rlBins = [15000,13000,12000,11000,10000,9000,8000,7000];
  aryRLs = pickBounds(runwayLength,rlBins);
  aryRLs[1] = aryRLs[0] + 1000;
  if (aryRLs[0] == 8500) aryRLs[1] = aryRLs[0] + 500;
  if (aryRLs[0] == 8000) aryRLs[1] = aryRLs[0] + 500;
  
  DSwindBounds.runwayLengthLow = aryRLs[0];
  DSwindBounds.runwayLengthHigh = aryRLs[1];
  
  if (temperature <= 50) DSwindBounds.temperatureLow = 15;
  if (temperature < 15) DSwindBounds.temperatureLow = -10;
  DSwindBounds.temperatureHigh = DSwindBounds.temperatureLow + 25;
  
  windBins = [40,20,0,-20,-40]
  aryWinds = pickBounds(Headwind, windBins);
  DSwindBounds.windLow = aryWinds[0];
  DSwindBounds.windHigh = aryWinds[1];

  // Calculations for DS with wind need to come in somewhere after this.
  // (from WindRCR sheet)
  // Calculations are not used in the spreadsheet code; no need to replicate here.
  
  
  
  
  
  
  // Establish altitude, weight, temperature, and wind bounds for Takeoff Distance wind data
  TODwindBounds = new Object();
  if (p <= 6) TODwindBounds.pressureAltLow = 2;
  if (p < 2) TODwindBounds.pressureAltLow = 0;
  TODwindBounds.pressureAltHigh = TODwindBounds.pressureAltLow + 2;
  
  if (weightIndex <= 14) TODwindBounds.weightLow = 12.5;
  if (weightIndex < 12.5) TODwindBounds.weightLow = 11.5;
  TODwindBounds.weightHigh = TODwindBounds.weightLow + 1;
  
  if (temperature <= 50) TODwindBounds.temperatureLow = 30;
  if (temperature < 30) TODwindBounds.temperatureLow = 10;
  if (temperature < 10) TODwindBounds.temperatureLow = -10;
  TODwindBounds.temperatureHigh = TODwindBounds.temperatureLow + 20;

  windBins = [40,20,10,0,-10,-20,-40];
  aryWinds = pickBounds(Headwind, windBins);
  TODwindBounds.windLow = aryWinds[0];
  TODwindBounds.windHigh = aryWinds[1];
  
  // Run calculations for TOD with wind, 50ftDistance with wind, TOD no wind, and 50ftDistance no wind
  // (From WindRCR sheet)
  
  // Calculate TWA values based on general bounds.
  aryTemperatures = [];
  for (i=0;i < 16;i = i + 2) {
    aryTemperatures[i] = TODwindBounds.temperatureLow;
    aryTemperatures[i+1] = TODwindBounds.temperatureHigh;
  }
  
  aryTemperaturesK = [];
  for (i=0;i < 16;i++) {
    aryTemperaturesK[i] = TC2K(aryTemperatures[i]);
  } 
  
  aryWinds = [];
  for (i=0;i < 8;i++) {
    aryWinds[i] = TODwindBounds.windLow;
    aryWinds[i+8] = TODwindBounds.windHigh;
  }   
   
  aryPressureAlts = [];
  for (i=0;i < 4;i++) {
    aryPressureAlts[i] = TODwindBounds.pressureAltLow;
    aryPressureAlts[i+4] = TODwindBounds.pressureAltHigh;
    aryPressureAlts[i+8] = TODwindBounds.pressureAltLow;
    aryPressureAlts[i+12] = TODwindBounds.pressureAltHigh;
  }
  
  aryWeights = [];
  for (i=0;i < 16;i = i + 4) {
    aryWeights[i] = TODwindBounds.weightLow;
    aryWeights[i+1] = TODwindBounds.weightLow;
    aryWeights[i+2] = TODwindBounds.weightHigh;
    aryWeights[i+3] = TODwindBounds.weightHigh;
  }    

  aryTWAWs = [];
  for (i=0;i < 16;i++) {
    aryTWAWs[i] = (aryTemperaturesK[i] * Math.pow(10,7)) + (aryWeights[i] * 1000) + (aryPressureAlts[i] * 10) + (aryWinds[i]/10);
  }
  // Perform lookups against TOData2 for Takeoff distance
  aryTODWithWindBase = [];
  for (i=0;i < aryTWAWs.length;i++) {
    aryTODWithWindBase[i] = TOData2[aryTWAWs[i]][0];
  }
  
  // Interpolate with wind as the factor (8 results)
  aryTODWWsInterpByWind = [];
  for (i=0;i < 8;i++) {
    aryTODWWsInterpByWind[i] = linterp(aryTODWithWindBase[i], aryTODWithWindBase[i+8], aryWinds[i], aryWinds[i+8], Headwind);
  }
    
  // Re-nterpolate with pressureAlt as the factor (4 results)  
  aryTODWWsInterpByPressureAlt = [];
  for (i=0;i < 4;i++) {
    aryTODWWsInterpByPressureAlt[i] = linterp(aryTODWWsInterpByWind[i], aryTODWWsInterpByWind[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paFloor);
  }
  
  // Re-interpolate with Weight as the factor (2 results)
  aryTOWWsInterpByWeight = [];
  for (i=0;i < 2;i++) {
    aryTOWWsInterpByWeight[i] = linterp(aryTODWWsInterpByPressureAlt[i], aryTODWWsInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Re-interpolate with temperature as the factor (1 result)
  TODwind = linterp(aryTOWWsInterpByWeight[0], aryTOWWsInterpByWeight[1], aryTemperatures[0], aryTemperatures[1], temperature);


  // Perform lookups against TOData2 for 50-foot distance
  aryFFDWithWindBase = [];
  for (i=0;i < aryTWAWs.length;i++) {
    aryFFDWithWindBase[i] = TOData2[aryTWAWs[i]][1];
  }
  
  // Interpolate with wind as the factor (8 results)
  aryFFDWWsInterpByWind = [];
  for (i=0;i < 8;i++) {
    aryFFDWWsInterpByWind[i] = linterp(aryFFDWithWindBase[i], aryFFDWithWindBase[i+8], aryWinds[i], aryWinds[i+8], Headwind);
  }
    
  // Re-nterpolate with pressureAlt as the factor (4 results)  
  aryFFDsInterpByPressureAlt = [];
  for (i=0;i < 4;i++) {
    aryFFDsInterpByPressureAlt[i] = linterp(aryFFDWWsInterpByWind[i], aryFFDWWsInterpByWind[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Re-interpolate with Weight as the factor (2 results)
  aryFFDsInterpByWeight = [];
  for (i=0;i < 2;i++) {
    aryFFDsInterpByWeight[i] = linterp(aryFFDsInterpByPressureAlt[i], aryFFDsInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Re-interpolate with temperature as the factor (1 result)
  FFDWithWind = linterp(aryFFDsInterpByWeight[0], aryFFDsInterpByWeight[1], aryTemperaturesK[0], aryTemperaturesK[1], temperatureK);
  
  
  
  aryTWAWs = [];
  for (i=0;i < 8;i++) {
    aryTWAWs[i] = (aryTemperaturesK[i] * Math.pow(10,7)) + (aryWeights[i] * 1000) + (aryPressureAlts[i] * 10);
  }
  
  // Perform lookups against TOData2 for Takeoff distance
  aryTODNoWindBase = [];
  for (i=0;i < aryTWAWs.length;i++) {
    aryTODNoWindBase[i] = TOData2[aryTWAWs[i]][0];
  }
    
  // Re-nterpolate with pressureAlt as the factor (4 results)  
  aryTONWsInterpByPressureAlt = [];
  for (i=0;i < 4;i++) {
    aryTONWsInterpByPressureAlt[i] = linterp(aryTODNoWindBase[i], aryTODNoWindBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paFloor);
  }
  
  // Re-interpolate with Weight as the factor (2 results)
  aryTONWsInterpByWeight = [];
  for (i=0;i < 2;i++) {
    aryTONWsInterpByWeight[i] = linterp(aryTONWsInterpByPressureAlt[i], aryTONWsInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Re-interpolate with temperature as the factor (1 result)
  TODnowind = linterp(aryTONWsInterpByWeight[0], aryTONWsInterpByWeight[1], aryTemperaturesK[0], aryTemperaturesK[1], temperatureK);


  // Perform lookups against TOData2 for 50-foot distance
  aryFFDNoWindBase = [];
  for (i=0;i < aryTWAWs.length;i++) {
    aryFFDNoWindBase[i] = TOData2[aryTWAWs[i]][1];
  }
  
  // Re-nterpolate with pressureAlt as the factor (4 results)  
  aryFFDsInterpByPressureAlt = [];
  for (i=0;i < 4;i++) {
    aryFFDsInterpByPressureAlt[i] = linterp(aryFFDNoWindBase[i], aryFFDNoWindBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Re-interpolate with Weight as the factor (2 results)
  aryFFDsInterpByWeight = [];
  for (i=0;i < 2;i++) {
    aryFFDsInterpByWeight[i] = linterp(aryFFDsInterpByPressureAlt[i], aryFFDsInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Re-interpolate with temperature as the factor (1 result)
  FFDNoWind = linterp(aryFFDsInterpByWeight[0], aryFFDsInterpByWeight[1], aryTemperaturesK[0], aryTemperaturesK[1], temperatureK);
  
  
  
  // Run calculations for CFL and CEFS
  // (From Calc sheet)
  // Calculate TWA values based on general bounds.
  aryTemperatures = [];
  for (i=0;i < 7;i=i+2) {
    aryTemperatures[i] = GeneralBounds.temperatureLow;
    aryTemperatures[i+1] = GeneralBounds.temperatureHigh;
  }
  
  aryTemperaturesK = [];
  for (i=0;i < 8;i++) {
    aryTemperaturesK[i] = TC2K(aryTemperatures[i]);
  }     
   
  aryWeights = [];
  for (i=0;i < 5;i = i + 4) {
    aryWeights[i] = GeneralBounds.weightLow;
    aryWeights[i+1] = GeneralBounds.weightLow;
    aryWeights[i+2] = GeneralBounds.weightHigh;
    aryWeights[i+3] = GeneralBounds.weightHigh;
  }    

  aryPressureAlts = [];
  for (i=0;i < 4;i++) {
    aryPressureAlts[i] = GeneralBounds.pressureAltLow;
    aryPressureAlts[i+4] = GeneralBounds.pressureAltHigh;
  }
  
  aryTWAs = [];
  for (i=0;i < 8;i++) {
    aryTWAs[i] = ((aryTemperaturesK[i] * Math.pow(10,6)) + (aryWeights[i] * 100) + aryPressureAlts[i]).toFixed(0);
  }
  
  // Lookup values for CFL from TOData table using temp, weight, altitude bounds.  These will be the basis for interpolation
  aryCFLBase = [];
  for (i=0;i < aryTWAs.length;i++) {
    aryCFLBase[i] = TOData[aryTWAs[i]][8];
  }

  // Interpolate with pressureAlt as the factor (4 results)  
  aryCFLsInterpByPressureAlt = [];
  for (i=0;i < 4;i++) {
    if (aryCFLBase[i] == 99999) aryCFLBase[i] = aryCFLBase[i+4];
    if (aryCFLBase[i+4] == 99999) aryCFLBase[i+4] = aryCFLBase[i];
    aryCFLsInterpByPressureAlt[i] = linterp(aryCFLBase[i], aryCFLBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }

  // Re-interpolate with weight as the factor (2 results)
  aryCFLsInterpByWeight = [];
  for (i=0;i < 2;i++) {
    if (aryCFLsInterpByWeight[i] == 99999) aryCFLsInterpByWeight[i] = aryCFLsInterpByWeight[i+2];
    if (aryCFLsInterpByWeight[i+2] == 99999) aryCFLsInterpByWeight[i+1] = aryCFLsInterpByWeight[i];
    aryCFLsInterpByWeight[i] = linterp(aryCFLsInterpByPressureAlt[i], aryCFLsInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Re-interpolate with temperature as the factor (1 result)
  if (aryCFLsInterpByWeight[0] == 99999) aryCFLsInterpByWeight[0] = aryCFLsInterpByWeight[1];
  if (aryCFLsInterpByWeight[1] == 99999) aryCFLsInterpByWeight[1] = aryCFLsInterpByWeight[0];
  CFL = linterp(aryCFLsInterpByWeight[0], aryCFLsInterpByWeight[1], aryTemperaturesK[0], aryTemperaturesK[1], temperatureK);
 
  if (Headwind != 0) CFL = CFLwind(CFL, Headwind);
  if (rcr < 23) CFL = CFLrcr(CFL, rcr);



  // Lookup values for CEFS from TOData table using temp, weight, altitude bounds.  These will be the basis for interpolation
  aryCEFSBase = [];
  for (i=0;i < aryTWAs.length;i++) {
    aryCEFSBase[i] = TOData[aryTWAs[i]][7];
  }
  
  // Interpolate with pressureAlt as the factor (4 results)  
  aryCEFSsInterpByPressureAlt = [];
  for (i=0;i < 4;i++) {
    if (aryCEFSBase[i] == 99999) aryCEFSBase[i] = aryCEFSBase[i+4];
    if (aryCEFSBase[i+4] == 99999) aryCEFSBase[i+4] = aryCEFSBase[i];
    aryCEFSsInterpByPressureAlt[i] = linterp(aryCEFSBase[i], aryCEFSBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }

  // Re-interpolate with weight as the factor (2 results)
  aryCEFSsInterpByWeight = [];
  for (i=0;i < 2;i++) {
    if (aryCEFSsInterpByWeight[i] == 99999) aryCEFSsInterpByWeight[i] = aryCEFSsInterpByWeight[i+2];
    if (aryCEFSsInterpByWeight[i+2] == 99999) aryCEFSsInterpByWeight[i+1] = aryCEFSsInterpByWeight[i];
    aryCEFSsInterpByWeight[i] = linterp(aryCEFSsInterpByPressureAlt[i], aryCEFSsInterpByPressureAlt[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }
  
  // Re-interpolate with temperature as the factor (1 result)
  if (aryCEFSsInterpByWeight[0] == 99999) aryCEFSsInterpByWeight[0] = aryCEFSsInterpByWeight[1];
  if (aryCEFSsInterpByWeight[1] == 99999) aryCEFSsInterpByWeight[1] = aryCEFSsInterpByWeight[0];
  CEFS = linterp(aryCEFSsInterpByWeight[0], aryCEFSsInterpByWeight[1], aryTemperatures[0], aryTemperatures[1], temperature);


  if (Headwind != 0) CEFS = CEFSwind(CEFS, Headwind);
  if (rcr < 23) CEFS = CEFSrcr(CEFS, rcr);



  // Run calculations for rot,Tos,Os,Seto,TOD,OD,Sero
  // (from Calc sheet)
  // JP: These were already done above--do we really need to repeat here?
  

  // Lookup values for 200FPNM from TOData table using temp, weight, altitude bounds.  These will be the basis for interpolation
  ary200FPNMBase = [];
  for (i=0;i < aryTWAs.length;i++) {
    ary200FPNMBase[i] = TOData[aryTWAs[i]][10];
  }

  // Interpolate with pressureAlt as the factor (4 results)  
  aryTNFPMInterpByPressureAlts = [];
  TFPNMFlag = 0;
  for (i=0;i < 4;i++) {
    if (ary200FPNMBase[i] == 99999) {
        ary200FPNMBase[i] = ary200FPNMBase[i+4];
        TFPNMFlag++;
    }
    if (ary200FPNMBase[i+4] == 99999) {
        ary200FPNMBase[i+4] = ary200FPNMBase[i];
        TFPNMFlag++;
    }
    aryTNFPMInterpByPressureAlts[i] = linterp(ary200FPNMBase[i], ary200FPNMBase[i+4], aryPressureAlts[i], aryPressureAlts[i+4], paIndex);
  }
  
  // Re-interpolate with weight as the factor (2 results)
  aryTFPNMsInterpByWeight = [];
  for (i=0;i < 2;i++) {
    if (aryTFPNMsInterpByWeight[i] == 99999) aryTFPNMsInterpByWeight[i] = aryTFPNMsInterpByWeight[i+2];
    if (aryTFPNMsInterpByWeight[i+2] == 99999) aryTFPNMsInterpByWeight[i+1] = aryTFPNMsInterpByWeight[i];
    aryTFPNMsInterpByWeight[i] = linterp(aryTNFPMInterpByPressureAlts[i], aryTNFPMInterpByPressureAlts[i+2], aryWeights[i], aryWeights[i+2], weightIndex);
  }      

  // Re-interpolate with temperature as the factor (1 result)
  if (aryTFPNMsInterpByWeight[0] == 99999) aryTFPNMsInterpByWeight[0] = aryTFPNMsInterpByWeight[1];
  if (aryTFPNMsInterpByWeight[1] == 99999) aryTFPNMsInterpByWeight[1] = aryTFPNMsInterpByWeight[0];
  TFPNM = linterp(aryTFPNMsInterpByWeight[0], aryTFPNMsInterpByWeight[1], aryTemperatures[0], aryTemperatures[1], temperature);
  // NOTE: TFPNM is represented as the variable vc in the spreadsheet VBA code

  
  if (Headwind != 0) TFPNM = vcwind(TFPNM, Headwind);
  
  
  if (TFPNMFlag > 4 && TFPNMFlag <= 6) {
    // iterate on secg to find speed required for 200 FT/NM Climb
    TFPNMFlag = 0;
    var vc2 = 140;
    var climb2 = 0;
    while (!((climb2 > 200) || (vc2 > 200))) {
      vc2 = vc2 + 4;
      climb2 = SECG152To200(temperature, acGrossWt, pressureAlt, vc2, 'dn');
      Vtrue = KCAS2KTAS(vc2, pressureAlt, temperature);
      NMPM = KT2fps(Vtrue) * 60 / 6076.12;
      climb2 = climb2 / NMPM;
    }
    if (vc2 > 200) TFPNMFlag = 8; // 200FPNM Unattainable
  
    // vc2 will provide a climb rate > than 200 ft/NM
    // interpolate between vc2 and vc1 to find the speed for 200 ft/nm
  
    var vc1 = vc2 - 4;
    var climb1 = SECG152To200(temperature, acGrossWt, pressureAlt, vc1, 'dn');
    Vtrue = KCAS2KTAS(vc1, pressureAlt, temperature);
    NMPM = KT2fps(Vtrue) * 60 / 6076.12;
    climb1 = climb1 / NMPM;
    vc = linterp(vc1,vc2,climb1,climb2,200);
    if (Headwind != 0) vc = vcwind(vc, Headwind);
  } 


  
  // Decision speed  
  // Set up arrays for Temp, RL, PA, and Weight based on DS bounds
  var aryDSTemperatures = [];
  var aryDSTemperaturesK = [];
  for (i=0;i<8;i++) {
    aryDSTemperatures[i] = GeneralBounds.temperatureLow;
    aryDSTemperaturesK[i] = GeneralBounds.temperatureLow + 273.15;
    aryDSTemperatures[i+8] = GeneralBounds.temperatureHigh;
    aryDSTemperaturesK[i+8] = GeneralBounds.temperatureHigh + 273.15;
  }

  var aryDSRunwayLengths = [];
  for (i=0;i<15;i=i+2) {
    aryDSRunwayLengths[i] = DSwindBounds.runwayLengthLow;
    aryDSRunwayLengths[i+1] = DSwindBounds.runwayLengthHigh;
  }
  
  var aryDSPressureAlts = [];
  for (i=0;i<4;i++) {
    aryDSPressureAlts[i] = GeneralBounds.pressureAltLow;
    aryDSPressureAlts[i+4] = GeneralBounds.pressureAltHigh;
    aryDSPressureAlts[i+8] = GeneralBounds.pressureAltLow;
    aryDSPressureAlts[i+12] = GeneralBounds.pressureAltHigh;
  }
  
  var aryDSWeights = [];
  for (i=0;i<16;i=i+4) {
    aryDSWeights[i] = GeneralBounds.weightLow;
    aryDSWeights[i+1] = GeneralBounds.weightLow;
    aryDSWeights[i+2] = GeneralBounds.weightHigh;
    aryDSWeights[i+3] = GeneralBounds.weightHigh;
  }
    
  lookupsDone = false;
  while (!lookupsDone) {
    // Calculate RTWA values
    aryRTWAs = [];
    for (i=0;i<16;i++) {
      aryRTWAs[i] = (aryDSRunwayLengths[i] * Math.pow(10,7) + (aryDSTemperaturesK[i]) * Math.pow(10,6) + aryDSWeights[i] * 100 + aryDSPressureAlts[i] * 1.0).toFixed(0);
    }

    // Do lookups against DS125 data
    aryDSBase = []
    for (i=0;i<16;i++) {
      aryDSBase[i] = DS125Data[aryRTWAs[i]];
      if (isNaN(aryDSBase[i])) {
        aryDSBase[i] = 0;
      }
    }
    lookupsDone = true;
   
    for (i=0;i<16;i++) {
      if (aryDSBase[i] == 999999) {
        lookupsDone = false;
        aryDSTemperatures[i] = aryDSTemperatures[i] - 10;
        aryDSTemperaturesK[i] = aryDSTemperatures[i] + 273.15;
      }
    }
  } // End while !lookupsDone 
  

  // Perform interpolation with Temperature as factor (8 results)
  aryDSInterpsByTemp = [];
  for (i=0;i<8;i++) {
    aryDSInterpsByTemp[i] = linterp(aryDSBase[i],aryDSBase[i+8], aryDSTemperatures[i], aryDSTemperatures[i+8], temperature);
  }
  
  // Perform interpolation with Pressure Altitude as factor (4 results)
  aryDSInterpsByPressureAlt = [];
  for (i=0;i<4;i++) {
    aryDSInterpsByPressureAlt[i] = linterp(aryDSInterpsByTemp[i],aryDSInterpsByTemp[i+4], aryDSPressureAlts[i],aryDSPressureAlts[i+4], paIndex);
  }
  
  // Perform interpolation with Weight as factor (2 results)
  aryDSInterpsByWeight = [];
  for (i=0;i<2;i++) {
    aryDSInterpsByWeight[i] = linterp(aryDSInterpsByPressureAlt[i],aryDSInterpsByPressureAlt[i+2],aryDSWeights[i],aryDSWeights[i+2], weightIndex);
  }
  
  // Perform interpolation with Runway Length as factor (1 result)
  DS = linterp(aryDSInterpsByWeight[0],aryDSInterpsByWeight[1],aryDSRunwayLengths[0],aryDSRunwayLengths[1], runwayLength);

  if (Headwind != 0) {
    DS = DSwindCorrect(DS, Headwind);
  }

  var RS_beo = rsbeo(temperature, pressureAlt, runwayLength, acGrossWt, Headwind, rcr, aerobrake);
  var RS_EF = rsef(temperature, pressureAlt, runwayLength, acGrossWt, Headwind, rcr, aerobrake);

  
  // Correct RS for RCR
  if (rcr < 23) {
    RS_beo = rsRCR(RS_beo, rcr, Headwind);
    RS_EF = rsRCR(RS_EF, rcr, Headwind);
  }
  

  // Correct TOD for wind
  zerowindTOD = TOD;
  if (runwaySlope > 0) zerowindTOD = zerowindTOD * (1.0 + 0.05 * runwaySlope);
  TOD = TOD * TODwind / TODnowind;

  // Correct 50 FT Obstacle for wind
  FFD = FFD * FFDWithWind / FFDNoWind;

  
  // Correct for Runway slope
  if (runwaySlope > 0) TOD = TOD * (1 * 1 + 0.05 * runwaySlope);
  if (runwaySlope > 0) FFD = FFD * (1 * 1 + 0.16 * runwaySlope);
  if (runwaySlope > 0) CFL = CFL * (1 * 1 + 0.04 * runwaySlope);
  if (runwaySlope < 0) CFL = CFL * (1 * 1 + 0.03 * runwaySlope);
  CEFS = CEFS + 3 * runwaySlope;


  // Correct for presence of WSSP
    TOD = TOD * (1.0 + 0.01 * podMounted);
    FFD = FFD * (1.0 + 0.01 * podMounted);
    SETOS = SETOS * 1 + 2 * podMounted;

  
  if (TOD >= 3000) macsD = 2000;
  if (TOD < 3000) macsD = 1000;
  
  NACS = NACS1(zerowindTOD, TOS, macsD, Headwind);

  for (i=0;i<3;i++) {
    if (NACS > CEFS) {
      macsD = macsD - 500;
      NACS = NACS1(zerowindTOD, TOS, macsD, Headwind);
    }
  }
  
  for (i=0;i<3;i++) {
    if (NACS > RS_beo) {
      macsD = macsD - 500;
      NACS = NACS1(zerowindTOD, TOS, macsD, Headwind);
    }
  }
  
  MACS = MACS1(NACS, CFL, runwayLength);

  // Velocity during Takeoff Ground Run
  if (Headwind != 0) SEGRB = distwind(SEGRB, Headwind); // correct baseline for wind

  // Use setos and an input failure speed to find the distance required to accelerate
  DistanceToSETOS_BEO = distreq(SETOS, RS_beo, SEGRB) * (1 * 1.0 + 0.01 * podMounted);
  DistanceToSETOS_EF = distreq(SETOS, RS_EF, SEGRB) * (1 * 1.0 + 0.01 * podMounted);
  DistanceToSETOS_GoNoGo = distreq(SETOS, givenEngFailAt, SEGRB) * (1 * 1.0 + 0.01 * podMounted);  

  
  if (runwaySlope > 0) {
    DistanceToSETOS_BEO = distreq(SETOS, RS_beo, SEGRB) * (1 + 0.1 * runwaySlope) * (1 * 1.0 + 0.01 * podMounted);
    DistanceToSETOS_EF = distreq(SETOS, RS_EF, SEGRB) * (1 + 0.1 * runwaySlope) * (1 * 1.0 + 0.01 * podMounted);
    DistanceToSETOS_GoNoGo = distreq(SETOS, givenEngFailAt, SEGRB) * (1 + 0.1 * runwaySlope) * (1 * 1.0 + 0.01 * podMounted);
  }

   
  // Calculate speed at end of runway given engine failure at RS
  // first find Distance traveled up to RS (DO THIS ONLY FOR VALID RS)
  RSD_BEO = (RDD(zerowindTOD, TOS, RS_beo, Headwind)) * (1 * 1.0 + 0.01 * podMounted);
  RR_BEO = (runwayLength - RSD_BEO) / (1 * 1.0 + 0.01 * podMounted); // Runway Remaining at RS_BEO
  if (runwaySlope > 0) {
      RR_BEO = RR_BEO / (1 * 1.0 + 0.1 * runwaySlope);
  }

  EORV_BEO = EORV(RS_beo, SEGRB, RR_BEO) - 1; // Velocity at end of runway
  //Worksheets("TOLD").Cells(77, 7) = EORV_BEO;
  var EORV_BEO_Exceeded = "";
  if (EORV_BEO > 200) {
    EORV_BEO_Exceeded = "> 200";
    EORV_BEO = 200;
  }
  
  
  RSD_EF = (RDD(zerowindTOD, TOS, RS_EF, Headwind)) * (1 * 1.0 + 0.01 * podMounted); // should this be wind TOD or modify rs_EF for wind???
  RR_EF = (runwayLength - RSD_EF) / (1 * 1.0 + 0.01 * podMounted); //Runway remaining at RS_EF
  if (runwaySlope > 0) {
      RR_EF = RR_EF / (1 * 1.0 + 0.1 * runwaySlope);
  }
  EORV_EF = EORV(RS_EF, SEGRB, RR_EF) - 1; // velocity at end of runway

  var EORV_EF_Exceeded = "";
  if (EORV_EF > 200) {
      EORV_EF_Exceeded = "> 200";
      EORV_EF = 200;
  }
  
  RSD_GnoG = (RDD(zerowindTOD, TOS, givenEngFailAt, Headwind)) * (1 * 1.0 + 0.01 * podMounted);
  RR_GnoG = (runwayLength - RSD_GnoG) / (1 * 1.0 + 0.01 * podMounted); // Runway Remaining at RS_BEO
  if (runwaySlope > 0) {
      RR_GnoG = RR_GnoG / (1 * 1.0 + 0.1 * runwaySlope);
  }
  EORV_GnoG = EORV(givenEngFailAt, SEGRB, RR_GnoG) - 1; // Velocity at end of runway give failure at engine failure speed (user input)
  //Worksheets("TOLD").Cells(56, 6) = EORV_GnoG;
  var EORV_GnoG_Exceeded = "";
  if (EORV_GnoG > 200) {
    EORV_GnoG_Exceeded = "> 200";
    EORV_GnoG = 200;
  }

  //Find Single engine climb gradient at end of runway with ef at RS-EF
  var GDSECG_EF = SECG152To200(temperature, acGrossWt, pressureAlt, EORV_EF, 'dn');
  var EORV_EF_KTAS = KCAS2KTAS(EORV_EF * 1.0 + 3, pressureAlt, temperature);
  var NMPM = KT2fps(EORV_EF_KTAS - Headwind) * 60 / 6076.12;
  GDSECG_EF = GDSECG_EF / NMPM;

  //Find Single engine GEAR UP climb gradient at end of runway with ef at RS-EF
  var GUSECG_EF = SECG152To200(temperature, acGrossWt, pressureAlt, EORV_EF, 'up');
  EORV_EF_KTAS = KCAS2KTAS(EORV_EF * 1.0 + 3, pressureAlt, temperature);
  NMPM = KT2fps(EORV_EF_KTAS - Headwind) * 60 / 6076.12;
  GUSECG_EF = GUSECG_EF / NMPM;

  //Find Single engine climb gradient at end of runway with ef at Go-no-Go (A.K.A engine fail speed(user iput))
  var GDSECG_EF_GnoG = SECG152To200(temperature, acGrossWt, pressureAlt, EORV_GnoG, 'dn');
  //Worksheets("TOLD").Cells(48, 9).Value = GNG_GDSECG_EF  //fpm
  EORV_GnoG_KTAS = KCAS2KTAS(EORV_GnoG * 1.0 + 3, pressureAlt, temperature);
  NMPM = KT2fps(EORV_GnoG_KTAS - Headwind) * 60 / 6076.12;
  GDSECG_EF_GnoG = GDSECG_EF_GnoG / NMPM;

  //Find Single engine GEAR UP climb gradient at end of runway with ef at Go-no-Go (A.K.A engine fail speed(user iput))
  GUSECG_EF_GnoG = SECG152To200(temperature, acGrossWt, pressureAlt, EORV_GnoG, 'up');
  //Worksheets("TOLD").Cells(45, 9).Value = secg1  //fpm
  EORV_GnoG_KTAS = KCAS2KTAS(EORV_GnoG * 1.0 + 3, pressureAlt, temperature);
  NMPM = KT2fps(EORV_GnoG_KTAS - Headwind) * 60 / 6076.12;
  GUSECG_EF_GnoG = GUSECG_EF_GnoG / NMPM;
  //Worksheets("TOLD").Cells(58, 6).Value = GUSECG_EF_GnoG //SECG gearUP Go-no-Go
  
  // Check SETO possibility
  SETO_not_possible = 0;
  for (k=0;k<5;k++) {
    var v = ((SETOS * 1) + (k * 5));
    var s = SECG152To200(temperature, acGrossWt, pressureAlt, v, 'dn');
    if (s < 300){
      SETO_not_possible++;
    }
    // The following two lines are pointless clock cycles if we don't need SECG at each v
    //Vtrue = KCAS2KTAS(SETOS + 3, pressureAlt, temperature);
    //NMPM = KT2fps(Vtrue - Headwind) * 60 / 6076.12;
    
  }
  
  if (CFL > runwayLength) {
    //gErrMsgs.push("CFL > Runway Length, MACS = NACS");
    MACS = NACS;
  }
  
  Headwind = Headwind.toFixed(0);
  //var MACS            = calcMACS();
  MACS = MACS.toFixed(0);
  //var MACSDistance    = calcMACSDistance();
  var MACSDistance = macsD.toFixed(0);
  //var DS              = calcDS();
  DS = DS.toFixed(0);
  //var RSEF            = calcRSEF();
  var RSEF = RS_EF.toFixed(0);
  //var SETOS           = calcSETOS();
  SETOS = SETOS.toFixed(0);
  //var SAEOR           = calcSAEOR();
  if (EORV_EF_Exceeded != "") {
    var SAEOR = EORV_EF_Exceeded;
  } else {
    var SAEOR = EORV_EF.toFixed(0);
  }  
  //var GearDNSECG     = calcGearDNSECG();
  var GearDNSECG = GDSECG_EF.toFixed(0);
  //var GearUPSECG     = calcGearUPSECG();
  var GearUPSECG = GUSECG_EF.toFixed(0);
  //var CFL             = calcCFL();
  CFL = CFL.toFixed(0);
  //var NACS            = calcNACS();
  NACS = (NACS*1.0).toFixed(0);
  //var RSBEO           = calcRSBEO();
  var RSBEO = RS_beo.toFixed(0);
  //var RotationSpeed   = calcRotationSpeed();
  var RotationSpeed = RS.toFixed(0);
  //var TakeoffSpeed    = calcTakeoffSpeed();
  var TakeoffSpeed = TOS.toFixed(0);
  //var TakeoffDistance = calcTakeoffDistance();
  var TakeoffDistance = TOD.toFixed(0);
  //var CEFS            = calcCEFS();
  CEFS = CEFS.toFixed(0);
  //var EFSAEOR         = calcEFSAEOR();
  if (EORV_GnoG_Exceeded != "") {
    var EFSAEOR = EORV_GnoG_Exceeded;
  } else {
    var EFSAEOR = EORV_GnoG.toFixed(0);
  }
  //var EFGearDNSECG   = calcEFGearDNSECG();
  var EFGearDNSECG = GDSECG_EF_GnoG.toFixed(0);
  //var EFGearUPSECG   = calcEFGearUPSECG();
  var EFGearUPSECG = GUSECG_EF_GnoG.toFixed(0);

  // Issue error messages if necessary
  if (givenEngFailAt * 1 > SETOS * 1 + 1) {
    gErrMsgs.push("Engine Failure Speed > SETOS");
    //SAEOR = "* * *";
    //GearDNSECG = "* * *";
    //EFSAEOR = "* * *";
  }
  
  if (DS > RS_EF){
    gErrMsgs.push("DS > RS-EF");
  }

  if (DS > TOS){
    gErrMsgs.push("DS > TOS");
    //DS = "* * *";
  }

  if (CEFS > SETOS){
    gErrMsgs.push("CEFS may be Invalid, CEFS > SETOS");
    //CEFS = "* * *";
  }
  
  if (RS_EF > SETOS) {
    gErrMsgs.push("RS > SETOS");
    //RSEF = "* * *";
    //SAEOR = "* * *";
    //GearDNSECG = "* * *";
  }

  if (RS_beo > TOS){
    gErrMsgs.push("RS > Takeoff Speed");
    //RSSBEO = "* * *";
  }
  /*
  if (TOD > runwayLength){
    gErrMsgs.push("Takeoff Distance > Runway Length");
    //TakeoffDistance = "* * *";
  }
  */
  
  if (SAEOR <= SETOS + 10) {
    gErrMsgs.push("Speed at EOR < SETOS + 10");
    //EFSAEOR = "* * *";
  }

  if ((SECG.toFixed(0) < 100) || SETO_not_possible == 5) {
    gErrMsgs = [];
    gErrMsgs.push("SETO not possible");
    MACS = "* * *";
    MACSDistance = "* * *";
    DS = "* * *";
    RSEF = "* * *";
    SETOS = "* * *";
    SAEOR = "* * *";
    GearDNSECG = "* * *";
    GearUPSECG = "* * *";
    CFL = "* * *";
    NACS = "* * *";
    RSBEO = "* * *";
    RotationSpeed = "* * *";
    TakeoffSpeed = "* * *";
    TakeoffDistance = "* * *";
    CEFS = "* * *";
    EFSAEOR = "* * *";
    EFGearDNSECG = "* * *";
    EFGearUPSECG = "* * *";
  }
  
  /*
  $("body").prepend("ACGW: " + acGrossWt + "<br />");
  $("body").prepend("Temp C: " + temperature  + "<br />");
  */
  $("#spnHeadwind").html(Headwind);
  $("#spnCrosswind").html(Crosswind);
  $("#spnMACS").html(MACS);
  $("#spnMACSDistance").html(MACSDistance);
  $("#spnDS").html(DS);
  $("#spnRSEF").html(RSEF);
  $("#spnSETOS").html(SETOS);
  $("#spnSAEOR").html(SAEOR);
  $("#spnGearDNSECG").html(GearDNSECG);
  $("#spnGearUPSECG").html(GearUPSECG);
  $("#spnCFL").html(CFL);
  $("#spnNACS").html(NACS);
  $("#spnRSBEO").html(RSBEO);
  $("#spnRotationSpeed").html(RotationSpeed);
  $("#spnTakeoffSpeed").html(TakeoffSpeed);
  $("#spnTakeoffDistance").html(TakeoffDistance);
  $("#spnCEFS").html(CEFS);
  $("#spnEFSAEOR").html(EFSAEOR);
  $("#spnEFGearDNSECG").html(EFGearDNSECG);
  $("#spnEFGearUPSECG").html(EFGearUPSECG);
  $("#spnGivenEngFailAt").html(givenEngFailAt);

  if (gErrMsgs.length) {
    htmlErrs = "<ul>";
    for (k=0;k < gErrMsgs.length;k++){
      htmlErrs += "<li>" + gErrMsgs[k] + "</li>";
    }
    htmlErrs += "<ul>";
    $("#divErrors").html(htmlErrs);
  }
  
  $(document).wipetouch({
    tapToClick: true, // if user taps the screen, triggers a click event
    wipeLeft: function(result) { 
                document.location='notes.html';
              },
    wipeRight: function(result) { 
                 history.back(1);
               }
  });
  $("#newCalcButton").click(function(){
    document.location='index.html';
  });
});

