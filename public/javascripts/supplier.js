
  // Shortcut to create new customer form
  function createSupplierInvoice() {
    var company_id = $("#invoice_company_id").val();
    
    $.get('/customers/new/' + company_id + '?ajax=1', {
    },
    function(data) {
      displayRemote(data);
      showRemote();
      
      $("#new_customer").bind("submit", function() {
        event.preventDefault();
        doCreateCustomerInvoice();
      });
    });
  }

  // Create new customer in the invoice via ajax
  function doCreateCustomerInvoice() {
    var company_id = $("#invoice_company_id").val();
    var name = $("#customer_name").val();
    var email = $("#customer_email").val();
    var account = $("#customer_account").val();
    var phone1 = $("#customer_phone1").val();
    var phone2 = $("#customer_phone2").val();
    var address1 = $("#customer_address1").val();
    var address2 = $("#customer_address2").val();
    var city = $("#customer_city").val();
    var state = $("#customer_state").val();
    var zip = $("#customer_zip").val();
    var country = $("#customer_country").val();
    var comments = $("#customer_comments").val();
    
    if($("#customer_taxable").attr("checked")) {
      var taxable = 1;
    } else {
      var taxable = 0;
    }
    
    if(name != "") {
      $.post('/customers/create_ajax/' + company_id, {
        name: name,
        email: email,
        account: account,
        phone1: phone1,
        phone2: phone2,
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        zip: zip,
        country: country,
        comments: comments,
        taxable: taxable
      },
      function(data) {
        if(data == "error_empty") {
          alert("Please enter a customer name");
        } else if(data == "error") {
          alert("Something went wrong when saving the customer, please try again");
        } else {
          var data_arr = data.split("|BRK|");
          
          $("#ac_customer").val(data_arr[1]);
          $("#ac_customer_id").val(data_arr[0]);
          $("#selected_customer").html(data_arr[1]);
          
          hideRemote();
          alert("The customer has been created");
        }
      });
    } else {
      alert("Please enter a customer name.");
    }
  }
