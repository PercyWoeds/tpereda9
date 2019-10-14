
  // Add an item to a product kit
  function addItemToSt2() {
    
    var item = $("#ac_item3").val();


   if(item != "") {
      var company_id = $("#tranportorder_company_id").val();
      var item_id = $("#ac_item_guia").val();        
      var items_arr = $("#items2").val().split(",");
      var item_line = item_id + "|BRK|" ;
        
        $("#items2").val($("#items2").val() + "," + item_line );

        listItemsSt2();
        
        $("#ac_item_guia").val("");
        $("#ac_item3").val("");      
      
    } else {
      alert("Por favor agregar una ST .");
    }
  }


  function listItemsSt2() {
    var items2 = $("#items2").val();
    var company_id = $("#tranportorder_company_id").val();
    
    $.get('/facturas/list_items3/'+ company_id,  {
      items2: items2
    },
    function(data) {
      $("#list_items2").html(data);
      documentReady();
    });
  }




 function removeItemFromSt2(id) {
    var items = $("#items2").val();
    var items_arr = items.split(",");
    var items_final = Array();
    var i = 0;
    
    while(i < items_arr.length) {
      if(i != id) {
        items_final[i] = items_arr[i];
      }
      i++;
    }
    
    $("#items2").val(items_final.join(","));
    listItemsSt2();
  }
