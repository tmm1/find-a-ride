$(document).ready(function() {
    typeaheadSearch();
    rideTime();
    rideDate();
    setTimeout(hideFlashMessages, 3500);
    $('.input-append').datepicker();
    
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
    
    // *** Confirmation dialog on deactivate user *** //
    $('#mymodal').modal({
        keyboard: false,
        show: false
    });

    $(".inactive_input").click(function(e){
        if ($('.inactive_input').attr("checked"))
        {
            $('#mymodal').modal('toggle');
        }
    });

    $("#confirm_yes").click(function(e){
        e.preventDefault();
        $('.inactive_input').attr("checked", "checked");
        $('#mymodal').modal('toggle');
    });

    $("#confirm_no").click(function(e){
        e.preventDefault();
        $('.inactive_input').attr("checked", null);
        $('#mymodal').modal('toggle');
    });
    
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
					    $('.notice-area').html("<div class='alert alert-success'>Your message has been successfully sent.</div>")	
					}
					else {
						$('.notice-area').html("<div class='alert alert-error'>There was a problem. Please retry later.</div>")
					}
					setTimeout(hideFlashMessages, 3500);
				}
			});
		}
    });	

});


function hideFlashMessages() {
    $('.alert').fadeOut(600);
}

var isValidEmail = function(email) {
    var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    return email_regex.test(email);
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
	$('#contact').find('#name').val('');
	$('#contact').find('#email').val('');
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
           
        },
        minTime: new Date
     
        
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

// ********* OLD CODE ********* DONT DELETE FOR NOW ***//
// 
// var constructContactMsg = function(origin, dest, matcher) {
//     if (matcher == 'drivers') {
//         return 'I see that you are looking to offer a ride from '+origin+' to '+dest+'. I m interested. Please get in touch with me so we can make this happen.'
//     }
//     else if (matcher == 'riders') {
//         return 'I see that you are looking to find a ride from '+origin+' to '+dest+'. I would be willing to share a ride with you. Please get in touch with me so we can make this happen.'
//     }
// }


// var initContactForm = function() {
//     $('.form_wrapper').find('.submit_button').click(function(e) {
//         e.preventDefault();
//         form_div = $(this).closest('.form_wrapper');
//         var contact_url = $(this).attr('post_url');
//         var contactor_id = form_div.find('#contacter_id').val();
//         var msg = form_div.find('#contact_msg').val();
//         var contactee_id = form_div.find('#contactee_id').val();
//         var origin = $('#origin').val();
//         var dest = $('#dest').val();
//         var matcher = $('#matcher').val();
//         if (typeof contactor_id == 'undefined') {
//             var name = form_div.find('#contact_name').val();
//             var email = form_div.find('#contact_email').val();
//             var phone = form_div.find('#contact_phone').val();
// 
//             if (name == '' || email == '') {
//                 form_div.find('.form_error').html('<h3>Need both name and email!</h3>');
//                 form_div.find('.form_error').fadeIn(400);
//             }
//             else if (!isValidEmail(email)) {
//                 form_div.find('.form_error').html('<h3>Need a valid email!</h3>');
//                 form_div.find('.form_error').fadeIn(400);
//             }
//             else {
//                 postContactMsg(contact_url, {
//                     contactee_id: contactee_id,
//                     matcher: matcher,
//                     user_info: {
//                         name: name,
//                         email: email,
//                         phone: phone
//                     },
//                     message: msg
//                 });
//             }
//         }
//         else {
//             postContactMsg(contact_url, {
//                 contactor_id: contactor_id,
//                 contactee_id: contactee_id,
//                 matcher: matcher,
//                 message: msg
//             });
//         }
//     });
// }
// 
// var postContactMsg = function(contact_url, post_data) {
//     $.ajax({
//         type: 'post',
//         url: contact_url,
//         data: post_data,
//         success: function(data) {
//             $('.form_error').hide();
//             $('.contact_form').hide();
//             $('.contact_response').html(data);
//             $('.contact_response').fadeIn(400);
//         },
//         failure: function(data) {
//         }
//     });
// }
// 
// var resetContactForm = function() {
//     var origin = $('#origin').val();
//     var dest = $('#dest').val();
//     var matcher = $('#matcher').val();
//     $('.contact_response').hide();
//     $('.form_wrapper').each(function (){
//         $(this).find('.form_error').hide();
//         $(this).find('#contact_name').val('');
//         $(this).find('#contact_email').val('');
//         $(this).find('#contact_phone').val('');
//         $(this).find('#contact_msg').val(constructContactMsg(origin, dest, matcher));
//     });
//     $('.contact_form').show();
// }
// 
// var locationSearch = function(){
//     var url = $('#data-url').val();   
//     var elem = $("input.autocomplete");
//     elem.unautocomplete();
//     elem.autocomplete(url,{
//         dataType: 'json',
//         extraParams: {
//             city: $("#city_select").val()
//         },
//         delay :200,
//         scroll: true,
//         scrollHeight: 300,
//         parse: function(data) {         
//             data = jQuery.grep(data, function (a) { return a != $("#ride_request_orig").val(); });            
//             var array = new Array();
//             for(var i=0; i<data.length; i++)
//             {
//                 array[array.length] = {
//                     data: data[i],
//                     value: data[i],
//                     result:data[i]
//                 };
//             }
//             return array;
//         },
//         formatItem: function(row) {
//             return row;
//         }
//     });
// }

