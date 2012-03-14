$(document).ready(function() {
    locationSearch();
    initRideSearch();
    setTimeout(hideFlashMessages, 5000);

    $('.carousel').carousel({
	  interval: 3000
	})
});


function hideFlashMessages() {
  $('.alert').fadeOut(400)
}

var isValidEmail = function(email) {
    var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    return email_regex.test(email);
}

var constructContactMsg = function(origin, dest, matcher) {
    if (matcher == 'drivers') {
        return 'I see that you are looking to offer a ride from '+origin+' to '+dest+'. I m interested. Please get in touch with me so we can make this happen.'
    }
    else if (matcher == 'riders') {
        return 'I see that you are looking to find a ride from '+origin+' to '+dest+'. I would be willing to share a ride with you. Please get in touch with me so we can make this happen.'
    }
}

var initRideSearch = function() {
    var search_url = $('#search_rides').attr('search_url');
    $('#search_rides').click(function() {
        var origin = $('#search_origin').val();
        var dest = $('#search_destination').val();
        var matcher = '';
        $('#flash_notice').hide();
        if ($('label.selected').attr('for') == 'search_get_ride') {
            matcher = 'drivers';
        }
        else {
            matcher = 'riders';
        }
        if (origin == '' || dest == '') {
            $('#search_error').fadeIn(400);
        }
        else {
            $('#search_error').hide();
            $('#submit').hide();
            $('#spinner_block').show();
            $.ajax({
                url: search_url,
                data: {
                    origin: origin,
                    dest: dest,
                    matcher: matcher
                },
                success: function(data) {
                    $('#search_block').hide();
                    $('#search_results_block').html(data);
                    $('#search_results_block').show();
                    initOverlays();
                    initPaginationLinks();
                    initContactForm();
                    $('.contact_click').click(function() {
                        resetContactForm();
                    });
                },
                failure: function(data) {
                    $('#submit').show();
                    $('#spinner_block').hide();
                }
            });
        }
    });
};

var initPaginationLinks = function() {
    $('#list .pagination a').click(function(e) {
        e.preventDefault();
        search_url = $(this).attr('href');
        $.ajax({
            url: search_url,
            success: function(data) {
                $('#search_results_block').html(data);
                $('#search_results_block').show();
                initOverlays();
                initPaginationLinks();
                initContactForm();
                $('.contact_click').click(function() {
                    resetContactForm();
                });
            },
            failure: function(data) {
            }
        });
    });
}

var initContactForm = function() {
    $('.form_wrapper').find('.submit_button').click(function(e) {
        e.preventDefault();
        form_div = $(this).closest('.form_wrapper');
        var contact_url = $(this).attr('post_url');
        var contactor_id = form_div.find('#contacter_id').val();
        var msg = form_div.find('#contact_msg').val();
        var contactee_id = form_div.find('#contactee_id').val();
        var origin = $('#origin').val();
        var dest = $('#dest').val();
        var matcher = $('#matcher').val();
        if (typeof contactor_id == 'undefined') {
            var name = form_div.find('#contact_name').val();
            var email = form_div.find('#contact_email').val();
            var phone = form_div.find('#contact_phone').val();

            if (name == '' || email == '') {
                form_div.find('.form_error').html('<h3>Need both name and email!</h3>');
                form_div.find('.form_error').fadeIn(400);
            }
            else if (!isValidEmail(email)) {
                form_div.find('.form_error').html('<h3>Need a valid email!</h3>');
                form_div.find('.form_error').fadeIn(400);
            }
            else {
                postContactMsg(contact_url, {
                    contactee_id: contactee_id,
                    matcher: matcher,
                    user_info: {
                        name: name,
                        email: email,
                        phone: phone
                    },
                    message: msg
                });
            }
        }
        else {
            postContactMsg(contact_url, {
                contactor_id: contactor_id,
                contactee_id: contactee_id,
                matcher: matcher,
                message: msg
            });
        }
    });
}

var postContactMsg = function(contact_url, post_data) {
    $.ajax({
        type: 'post',
        url: contact_url,
        data: post_data,
        success: function(data) {
            $('.form_error').hide();
            $('.contact_form').hide();
            $('.contact_response').html(data);
            $('.contact_response').fadeIn(400);
        },
        failure: function(data) {
        }
    });
}

var resetContactForm = function() {
    var origin = $('#origin').val();
    var dest = $('#dest').val();
    var matcher = $('#matcher').val();
    $('.contact_response').hide();
    $('.form_wrapper').each(function (){
        $(this).find('.form_error').hide();
        $(this).find('#contact_name').val('');
        $(this).find('#contact_email').val('');
        $(this).find('#contact_phone').val('');
        $(this).find('#contact_msg').val(constructContactMsg(origin, dest, matcher));
    });
    $('.contact_form').show();
}

var locationSearch = function(){
    var url = $('#data-url').val();   
    var elem = $("input.autocomplete");
    elem.unautocomplete();
    elem.autocomplete(url,{
        dataType: 'json',
        extraParams: {
            city: $("#city_select").val()
        },
        delay :200,
        scroll: true,
        scrollHeight: 300,
        parse: function(data) {         
            data = jQuery.grep(data, function (a) { return a != $("#ride_request_orig").val(); });            
            var array = new Array();
            for(var i=0; i<data.length; i++)
            {
                array[array.length] = {
                    data: data[i],
                    value: data[i],
                    result:data[i]
                };
            }
            return array;
        },
        formatItem: function(row) {
            return row;
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
    })
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
                timeFormat: 'h:mm:ss p',
                interval: 30
           });
}

var rideDate = function(){
		$( "input.datepicker" ).datepicker({
                     nextText: '',
                     prevText: '',
                     dateFormat: 'yy-mm-dd'
                });
	}

var rideOriginDest = function(){
            $("#ride_request_orig").live("change",function(){
               $("#ride_request_dest").val("");
            });
}
var rideRequestValidate = function(){
          $("#new_ride_request").validate({
                       rules: {
                            "ride_request[orig]": {
                                                    required: true,
                                                    notEqualTo: "#ride_request_dest"
                                                   },
                            "ride_request[dest]":  {
                                                    required: true,
                                                    notEqualTo: "#ride_request_orig"
                                                   },
                            "ride_request[start_date]": {required: true},
                            "ride_request[start_time]": {required: true}
                             }
           });
}
var rideOfferValidate = function(){
          $("#new_ride_offer").validate({
                       rules: {
                            "ride_offer[orig]": {
                                                    required: true,
                                                    notEqualTo: "#ride_offer_dest"
                                                   },
                            "ride_offer[dest]":  {
                                                    required: true,
                                                    notEqualTo: "#ride_offer_orig"
                                                   },
                            "ride_offer[start_date]": {required: true},
                            "ride_offer[start_time]": {required: true}
                             }
            });
}