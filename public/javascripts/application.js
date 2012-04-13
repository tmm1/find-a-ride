$(document).ready(function() {
    var inactive_chkbox = false;
    typeaheadSearch();
    rideTime();
    rideDate();
    setTimeout(hideFlashMessages, 3500);

    $('.input-append').datepicker();
    
    $('.result-popover').popover({
      title: 'Other Information'
    });

    // *** set carousel interval *** //
    $('.carousel').carousel({
        interval: 3500
    });
	
    // *** define tooltip on input fields across the app *** //
    $('.text-input').tooltip({
        title: $('.text-input').attr('title'),
        placement: 'right',
        trigger: 'focus'
    })

    //*** full-trace dialog ***//
    $("a#full-trace").click(function(e){
        $("#fulltrace").show();
    })
 
    
    // *** Confirmation dialog on deactivate user *** //
    $('#mymodal').modal({
        keyboard: false,
        show: false
    });

    //*** dialog for showing exception ***//
    $('#exception').modal({
        keyboard: false,
        show: false
    });

    $(".inactive_input").click(function(e){
        if ($('.inactive_input').attr("checked")) {
            $('#mymodal').modal('toggle');
        } else {
          inactive_chkbox = false;  
        }
    });

    $('#mymodal').on('hide', function(){
      if (!inactive_chkbox) {
        $('.inactive_input').attr("checked", null);
        inactive_chkbox = false;
      }
    })

    $("#confirm_yes").click(function(e){
        e.preventDefault();
        inactive_chkbox = true;
        $('.inactive_input').attr("checked", "checked");
        $('#mymodal').modal('toggle');
    });

    $("#confirm_no").click(function(e){
        e.preventDefault();
        inactive_chkbox = false;
        $('.inactive_input').attr("checked", null);
        $('#mymodal').modal('toggle');
    });
    
    // *** Hook up form *** //
    $(".modal.hide.hookclass").on('show', function(){
        var obj =  $(this)
        $.ajax({
                type: 'GET',
                url: $(this).attr('url'),
                success: function(data) {                                  
                        obj.html(data)
                        hookupSubmit(); //hook-up handler
                }
            });
    })
  
    // *** Contact form *** //    
    $('#contact').on('show', function () {
        resetContactForm(true);
    })

    $("#contact-submit").click(function(e){
        $('#contact').find('.inline-errors').remove();
        var errors = false;
        var url = $('#contact').attr('url');
        var name = $('#contact').find('#name');
        var email = $('#contact').find('#email');
        var about = $('#contact').find('#about').val();
        var comments = $('#contact').find('#comments');
        if (name.val() === '' || name.val() === undefined) {
            errors = true;
            name.after("<p class='inline-errors'>can't be blank</p>");
        }
        if (email.val() === '' || email.val() === undefined || !isValidEmail(email.val())) {
            errors = true;
            email.after("<p class='inline-errors'>can't be blank or invalid</p>");
        }
        if (comments.val() === '' || comments.val() === undefined) {
            errors = true;
            comments.after("<p class='inline-errors'>can't be blank</p>");
        }
        if (!errors) {
            $("#contact-submit").hide();
            $('#contact').find('.loader').show();
            $.ajax({
                type: 'POST',
                url: url,
                data: {
                    name: name.val(),
                    email: email.val(),
                    about: about,
                    comments: comments.val()
                },
                success: function(data) {
                    $('#contact').modal('hide');
                    if (data === 'success') {
                        $('.notice-area').html("<div class='alert alert-success'>Thanks for your input!</div>")
                    }
                    else {
                        $('.notice-area').html("<div class='alert alert-error'>There was a problem. Please retry later.</div>")
                    }
                    setTimeout(hideFlashMessages, 3500);
                }
            });
        }
    });	


    /* *************************** Delete Ride *********************************** */
    function initDeleteRideHandlers() {
      $(".tab-content .disabled").popover({title: "Cannot Delete"});

      $(".delete-ride").click(function(e) {
        e.preventDefault();
        var matches = $(this).attr('id').match(/(\d+)$/),
            rideId = matches[1];
        $(this).hide();
        $("#confirm-delete-" + rideId).show();
      });

      $(".yes, .no", ".confirm-delete").click(function(e) {
        e.preventDefault();

        var matches = $(this).parent().attr("id").match(/(\d+)$/),
            rideId = matches[1];

        // clicked "Sure?"
        if($(this).hasClass("yes")) {

          var url = $("#delete-ride-" + rideId).attr('href');

          var matches = $("#delete-ride-" + rideId).closest("div.tab-pane")
                          .find(".pagination .active a").attr("href").match(/(\w+)=(\d+)$/),
              key = matches[1],
              value = matches[2],
              dataArray = {};

          // adjusting the page number
          if((parseInt(value) > 1) &&
            ($("#delete-ride-" + rideId).closest("div.tab-pane").find(".delete-ride-cell").size() == 1)) {
            value = parseInt(value) - 1;
          }

          dataArray[key] = value;

          $.ajax({
            type: 'DELETE', url: url, data: dataArray,
            beforeSend: function() {
              $("#delete-ride-" + rideId).hide();
              $("#confirm-delete-" + rideId).hide();
              $("#ride-loader-" + rideId).show();
            },
            complete: function() {
              $("#ride-loader-" + rideId).hide();
              $("#delete-ride-" + rideId).show();
            }
          });
        }
        // clicked "No"
        else {
          $("#confirm-delete-" + rideId).hide();
          $("#delete-ride-" + rideId).show();
        }
      });
    }

    $(".tab-content").ajaxComplete(initDeleteRideHandlers);
    initDeleteRideHandlers();
    /* *************************** Delete Ride *********************************** */

});


/** utility methods **/

var isValidEmail = function(email) {
    var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    return email_regex.test(email);
}

var isValidMobile = function(phone){
    var phone_regex = /^[1-9]+\d{9}$/;
    return phone_regex.test(phone);
}

function hideFlashMessages() {
    $('.alert').fadeOut(600);
}

var resetContactForm = function(toggle) {
    $('#contact').find('.inline-errors').remove();
    if (toggle) {
        $("#contact-submit").show();
        $('#contact').find('.loader').hide();
    }
    else {
        $("#contact-submit").hide();
        $('#contact').find('.loader').show();
    }
    $("#contact-submit").show();
    $('#contact').find('.loader').hide();
    if ($('#user_login_status').val() == 'false'){
        $('#contact').find('#name').val('');
        $('#contact').find('#email').val('');
    }
    $('#contact').find('#comments').val('');
}

// Note that using Google Gears requires loading the Javascript
// at http://code.google.com/apis/gears/gears_init.js
function initGeolocation() {
    var myOptions = {
        zoom: 6,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var coordLocation;
    var defaultLocation = new google.maps.LatLng(17.385044, 78.486671); //Hyderabad
    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    // Try W3C Geolocation (Preferred)
    
    if(navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            coordLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
            map.setCenter(coordLocation);
            setAppCity(coordLocation);

        });
    }
    else {
        map.setCenter(defaultLocation);
        setAppCity(defaultLocation);
    }
}

var rideTime = function(){
    $('input.timepicker').timepicker({
        timeFormat: 'h:mm p',
        interval: 30,
        blur: function(time) {

            alert($.fn.timepicker.parseTime('h:mm p',time));
           
        }
    });
}

var rideDate = function(){
    $( "input.datepicker" ).datepicker({
        nextText: '',
        prevText: '',
        dateFormat: 'dd-mm-yy',
        minDate: new Date
    });
}

var rideOriginDest = function(){
    $("#ride_request_orig").live("change",function(){
        $("#ride_request_dest").val("");
    });
}

var typeaheadSearch = function(){
    $('.typeahead').typeahead({
        source: function (typeahead, query) {
            return  $.ajax({
                url: '/location_search?q='+query,
                dataType: 'json',
                success: function(data) {
                    return typeahead.process(data);
                },
                failure : function(){
                }
            })
        }
    });
}

var hookupSubmit =  function(){
      $("#hook-submit").click(function(){       
        $('#hook-up').find('.inline-errors').remove();
        var errors = false;
        var url = $('#new_hook_up').attr('action');       
        var hook_id = $('#hook-up').find('#hook_up_uniq_id').val();
        var message = $('#hook-up').find('#hook_up_message');
        var phone = $('#hook-up').find('#hook_up_mobile');
        if (message.val() === '' || message.val() === undefined) {
            errors = true;
            message.after("<p class='inline-errors'>can't be blank</p>");
        }
        if (phone.val() !== '' && !isValidMobile(phone.val())) {           
            errors = true;
            phone.after("<p class='inline-errors'>can't be invalid</p>");
        }
        if (!errors) {
            $("#hook-submit").hide();
            $('#hook-up').find('.loader').show();
            $.ajax({
                type: 'POST',
                url: url,
                data: $("#new_hook_up").serialize(),
                success: function(data) {
	                console.log($('#hook-up-'+hook_id));
                    $('#hook-up-'+hook_id).modal('hide');
                    if (data === 'success') {
                        $('.notice-area').html("<div class='alert alert-success'>Thanks! The other user should receive a notification.</div>")
                    }
                    else {
                        $('.notice-area').html("<div class='alert alert-error'>There was a problem. Please retry later.</div>")
                    }
                    setTimeout(hideFlashMessages, 3500);
                }
            });
        }
    });
}

function setAppCity(location){
    var url = $('#geocode_city_url').val();
    $.ajax({
        url: url,
        data: {
            lat_long: location.toString()
        },
        success: function(data) {
        },
        failure : function(){
        }
    });
}




