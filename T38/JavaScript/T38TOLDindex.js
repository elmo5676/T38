function clearForm(){
  $("#frmTOLD").get(0).reset();
}

function calcTOLDWt() {
  var pod = $("input:radio[name=podMounted]:checked").val() == 1;
  var tWt = $("#acGrossWt").val();
  var pcw = $("#podCargoWt").val();
  if (pod) {
    tWt = (tWt * 1) + (pcw * 1) + (110 * 1);
  }
  $("#wtUsedForTOLD").val(tWt);
}

$(document).ready(function(){
  //$("#divRestrictions").hide();
  // $("#givenEngFailAt").val(0);
  
  $(".selectOnFocus").focus(function(){
    this.setSelectionRange(0, 9999);
    return false;
  }).mouseup(function(){
    return false;
  });
  
  /*if ( Get_Cookie( 'TOLDRestrictionAck' ) != 'acknowledged' ) {
    $("#divRestrictions").dialog({modal: true,
                                  width: '600px'});
    $("#pRestrictionsAck").click(function(){
      $("#divRestrictions").dialog( "destroy" );
      Set_Cookie( 'TOLDRestrictionAck', 'acknowledged', '', '/', '', '' );
    });
  }*/

  $("#frmTOLD").validate({messages: {wtUsedForTOLD: "Adjust ACGW or cargo wt; 14000 is max"}});
   
  calcTOLDWt();

  $("#temperature").blur(function(){
    if ($("#temperatureScaleC").is(':checked') && $("#temperature").val() > 50){
      $("#temperature").val(50);
    }
  });
                  
  $("#acGrossWt").change(function(){
                         calcTOLDWt();
                         });
  $("#podMountedNo, #podMountedYes").click(function(){
                                           calcTOLDWt();
                                           });
  $("#podCargoWt").change(function(){
                         calcTOLDWt();
                         });
                  
  $("#resetFormButton").click(function(){
    clearForm();
  });
  
  $("#divTouchToCalculate").click(function(){
    $("#frmTOLD").submit();
  });
  
  $(document).keyup(function(e) {
    if(e.which == 13)
    {
      $("#frmTOLD").submit();
    }
  });
  
});
