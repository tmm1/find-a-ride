$(document).ready(function() {
    var user_inactive_check = false;
	  var pusher_channel = null;
    typeaheadSearch();
    rideTime();
    rideDate();
    rideOfferSearch();
    gmailContacts();
    initializePusher();
    alertInfo();
    // init facebook handler
    facebookInviteFriends();
    
    $('.input-append').datepicker();
    
    $('#contact-form textarea#comments').placeHeld();
    
    // *** set carousel interval *** //
    $('.carousel').carousel({
        interval: 3500
    });

    $("#ride_time, #vehicle").change(function(e){
            e.preventDefault();
            var url = $("#ride_offer_url").val()
            var ride_time = $("#ride_time").val()
            var vehicle = $("#vehicle").val()
            var ride_orig = $('#ride_orig').val();
            var ride_dest = $('#ride_dest').val();
            rideOffersList(url, {ride_time: ride_time, vehicle: vehicle, orig: ride_orig, dest: ride_dest});
     });
	
    // *** define tooltip on input fields across the app *** //
    $('.text-input').tooltip({
        title: $('.text-input').attr('title'),
        placement: 'right',
        trigger: 'focus'
    });

    //*** full-trace dialog ***//
    $("a#full-trace").click(function(e){
        $("#fulltrace").show();
    });

    //*** dialog for showing exception ***//
    $('#exception').modal({
        keyboard: false,
        show: false
    });
    
    /***  user inactive confirm dialog ***/
    $('#mymodal').modal({
        keyboard: false,
        show: false
    });

    $(".inactive_input").click(function(e){
        if ($('.inactive_input').attr("checked")) {
            $('#mymodal').modal('toggle');
            $("#user_inactive").focus().blur();
        } else {
            user_inactive_check = false;
        }
    });

    $('#mymodal').on('hide', function(){
        $("#user_inactive").focus();
        if (!user_inactive_check) {
            $('.inactive_input').attr("checked", null);
            user_inactive_check = false;
        }
    })

    $("#confirm_yes").click(function(e){
        e.preventDefault();
        user_inactive_check = true;
        $('.inactive_input').attr("checked", "checked");
        $('#mymodal').modal('toggle');
    });

    $("#confirm_no").click(function(e){
        e.preventDefault();
        user_inactive_check = false;
        $('.inactive_input').attr("checked", null);
        $('#mymodal').modal('toggle');
    });
    
    /*** Hook up modal ***/
    if($('.search-results').length > 0) {

      $('.search-results').ajaxComplete(initSearchResultsPopovers);
      initSearchResultsPopovers();

      $('body').on('click', 'a.hookup', function(e) {
        e.preventDefault();

        $("#hook-up").html($("#hookup-modal-template").tmpl(rides[$(this).attr('data-ride_id')]));
        $("#hook-up").modal({keyboard: 'false'});
      });

      $('body').on('click', '#hook-submit', function(e){
          e.preventDefault();

          $('#hook-up').find('.inline-errors').remove();
          var valid = true;
          var url = $('#new_hook_up').attr('action');
          var hook_id = $('#hook-up').find('#hook_up_uniq_id').val();
          var message = $('#hook-up').find('#hook_up_message');
          var phone = $('#hook-up').find('#hook_up_mobile');
          if (message.val() === '' || message.val() === undefined) {
              valid = false;
              message.after("<p class='inline-errors'>can't be blank</p>");
          }
          if (phone.val() !== '' && !isValidMobile(phone.val())) {
              valid = false;
              phone.after("<p class='inline-errors'>can't be invalid</p>");
          }
          if (valid) {
              $("#hook-submit").hide();
              $('#hook-up').find('.loader').show();
              $.ajax({
                  type: 'POST',
                  url: url,
                  data: $("#new_hook_up").serialize(),
                  success: function(data) {
                      $('#hook-up').modal('hide');
                      if (data === 'success') {
                          $('.notice-area').html("<div class='alert alert-success'>Your message was successfully sent. Please wait to hear back.</div>")

                          // updating the result row
                          var rideId = $('input[name="hook_up[hookable_id]"]', '#hook-up').val(),
                              hookup_link = $('[data-ride_id="' + rideId + '"]'),
                              hookup_label = hookup_link.html();
                          hookup_link.closest('#hook-up-popover' + hook_id).attr('data-content',
                            'Ah, It looks like you already might be in touch with this user!');
                          hookup_link.replaceWith('<span class="btn btn-medium btn-primary disabled">' + hookup_label + '</span>');
                      }
                      else {
                          $('.notice-area').html("<div class='alert alert-error'>There was a problem. Please retry later.</div>")
                      }
                      alertInfo();
                  }
              });
          }
      });
    }

    /*** Contact modal ***/
    $('#contact').on('show', function () {
      resetContactForm(true);
      $('.contact-modal-link').find('a').attr('href', '');
    })

    $('#contact').on('hide', function () {
      $('.contact-modal-link').find('a').attr('href', '#contact');
    });

    $("#contact-submit").click(function(e){
        $('#contact').find('.inline-errors').remove();
        var valid = true;
        var url = $('#contact').attr('url');
        var name = $('#contact').find('#name');
        var email = $('#contact').find('#email');
        var about = $('#contact').find('#about').val();
        var comments = $('#contact').find('#comments');
        if (name.val() === '' || name.val() === undefined) {
            valid = false;
            name.after("<p class='inline-errors'>can't be blank</p>");
        }
        if (email.val() === '' || email.val() === undefined || !isValidEmail(email.val())) {
            valid = false;
            email.after("<p class='inline-errors'>can't be blank or invalid</p>");
        }
        if (comments.val() === '' || comments.val() === undefined) {
            valid = false;
            comments.after("<p class='inline-errors'>can't be blank</p>");
        }
        if (valid) {
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
                        $('.notice-area').html("<div class='alert alert-success'>Thanks! Your message was successfully sent.</div>")
                    }
                    else {
                        $('.notice-area').html("<div class='alert alert-error'>There was a problem. Please retry later.</div>")
                    }
                    alertInfo();
                }
            });
        }
    });

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

    /** Delete Ride **/
    if($('.ride-list').length > 0) {

      // Show confirmation buttons
      $('.ride-list').on('click', '.delete-ride', function(e) {
        e.preventDefault();
        $(".delete-ride").show();
        $(".confirm-delete").hide();
        var matches = $(this).attr('id').match(/(\d+)$/),
            rideId = matches[1];
        $(this).hide();
        $("#confirm-delete-" + rideId).show();
      });

      // Handle confirmation buttons
      $('.ride-list').on('click', '.confirm-delete .yes, .confirm-delete .no', function(e) {
        e.preventDefault();

        var matches = $(this).parent().attr("id").match(/(\d+)$/),
            rideId = matches[1];

        // clicked "Sure?"
        if($(this).hasClass("yes")) {

          var url = $("#delete-ride-" + rideId).attr('href'),
              current_page = $("#delete-ride-" + rideId).closest("div.tab-pane").find(".pagination .active a"),
              dataArray = {};

          if(current_page.length > 0) {
            var matches = current_page.attr("href").match(/(\w+)=(\d+)$/),
                key = matches[1], value = matches[2];

            // adjusting the page number
            if((parseInt(value) > 1) &&
              ($("#delete-ride-" + rideId).closest("div.tab-pane").find(".delete-ride-cell").size() == 1)) {
              value = parseInt(value) - 1;
            }

            dataArray[key] = value;
          }
          else {
            var currentTab = $("#delete-ride-" + rideId).closest("div.tab-pane").attr("id"),
                key = currentTab.replace(/^([a-z]+)-([a-z]+)s$/, '$1_$2_page'),
                value = 1;
            dataArray[key] = value;
          }

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

      $(".ride-list").ajaxComplete(initDeleteRidePopovers);
      initDeleteRidePopovers();
    }



  $("#gmail-contacts-button").click(function(e){
    $('#import-gmail-contacts').find('.inline-errors').remove();
    $("#import-gmail-contacts").find('.loader').hide();
    $("#gmail_userid").val('');
    $("#gmail_password").val('');
    $("#import-modal").show();
    $("#contacts-modal").hide();
    gmailContacts();
  });

    /** Invite friend via email **/
    $("#invites_submit").click(function(e){
        e.preventDefault();
        valid = false;
        $('#invite1').find('.inline-errors').remove();
        $('#invite2').find('.inline-errors').remove();
        $('#invite3').find('.inline-errors').remove();
        var url = $('form').attr('action');
        var contacts_type = $('.accordion-body.in').find("#contact_type").val();
        var emails;
        var passwords;
        emails = $('#invite1').find('#invites_email');
        var token = $("input[name=authenticity_token]").val();   
        if (emails.val() === '' || (passwords && passwords.val() === '') ) {
            if (emails.val() === ''){
              emails.after("<p class='inline-errors'>can't be blank</p>");
            }
            if (passwords && passwords.val() === ''){
              passwords.after("<p class='inline-errors'>can't be blank</p>");
            }
        }
        else {
          email_list = emails.val().split(",");
          if(email_list.length > 25){
           valid = false;
           emails.after("<p class='inline-errors'>only maximum of 25 emails</p>");
          }
            else
            {
          for(var i=0; i<email_list.length; i++) {
            if (isValidEmail(email_list[i])) {
              valid = true;
            } else {
              valid = false;
              emails.after("<p class='inline-errors'>can't be invalid</p>");
              break;
            }
          }
        }
        }
        if (valid) {
	        $("#invites_submit").hide();
          $('.inputs').find('.loader').show();
          send_email_invites(email_list, token, url);
          setTimeout(function(){
            $('.inputs').find('.loader').hide();
            $("#invites_submit").show();
            emails.val('');
          }, 1000);
        }
        
    });	

    /** Fetch gmail contacts **/
	function gmailContacts(){
	  $("#fetch-gmail-contacts").unbind('click').bind('click', function(e){
	    e.preventDefault();
	    $('#import-gmail-contacts').find('.inline-errors').remove();
	    var email = $("#gmail_userid");
	    var password = $("#gmail_password");
	    var url = $('#invite2').attr('data-service-url');
	    if (email.val() === '' || password.val() === ''){
	      if (email.val() === ''){
	        email.after("<p class='inline-errors'>can't be blank</p>");
	      }
	      if (password.val() === ''){
	        password.after("<p class='inline-errors'>can't be blank</p>");
	      }
	    }
	   else{
	     $("#fetch-gmail-contacts").hide();
	     $("#import-gmail-contacts").find('.loader').show();
	     $.ajax({
	       type: 'GET',
	       url: url,
	       data: {
	         login: email.val(),
	         password: password.val()
	       },
	       success: function(data) {
	         $("#import-gmail-contacts").find('.loader').hide();
	         if (data.error_msg != '' && data.error_msg != undefined){
	           $("#fetch-gmail-contacts").show();
	           password.after("<p class='inline-errors'><br />"+data.error_msg+"</p>");
	         }
	         else{
	           $("#invite-gmail-contacts").click(function(e){
	             e.preventDefault();
	             $('#import-gmail-contacts').find('.inline-errors').remove();
	             var selected_gmail_contacts = '';
	             var tot_checked = $("input:checkbox[name=contact_list]:checked").length;
	             var i = 1;
	             if ($("input:checkbox[name=contact_list]:checked").length > 0) {
                         if ($("input:checkbox[name=contact_list]:checked").length > 25){
                          $("#no-selection-error").append("<p class='inline-errors'> only maximum of 25 emails </p>");
                         }
                         else {
	               $("#invite-gmail-contacts").hide();
	               $("#import-gmail-contacts").find('.loader').show();
	               $("input:checkbox[name=contact_list]:checked").each(function(){
	                 if (i < tot_checked) {
	                   selected_gmail_contacts = selected_gmail_contacts + $(this).attr('id') + ',';
	                 } else {
	                   selected_gmail_contacts = selected_gmail_contacts + $(this).attr('id');
	                 }
	                 i += 1;
	               });
	               var email_list = selected_gmail_contacts.split(',');
	               var token = $("input[name=authenticity_token]").val();
	               var url = $('form').attr('action');
	               send_email_invites(email_list, token, url);
	               setTimeout(function(){
	                 $("#import-gmail-contacts").find('.loader').hide();
	                 $("#import-gmail-contacts").modal('hide');
	               }, 1000);
                     }
	             }

                     else {
	               $("#no-selection-error").append("<p class='inline-errors'> No email addresses selected </p>");
	             }
	           });
	         }
	       }
	     });
	   }
	  });
	}
	
	/*** alert notifications using pusher ***/
    function initializePusher() {
		if (pusher_channel === null || pusher_channel === undefined) {
			var pusher = new Pusher($('#pusher-app-key').val()); 
			pusher_channel = pusher.subscribe($('#pusher-channel').val());
		}
    }

	pusher_channel.bind($('#pusher-event').val(), function(data) {
	  if ($('#pusher-receiver').val() === data.user_id) {
		$('.alert-badge').html(data.message);
	  }
	});

  /*** user alert content ***/
  if($('.user-alerts').length > 0) {
    $('.user-alerts').on('click', '.alert-row', function(e) {
      var alertRow = $(this);
      var target = alertRow.attr("data-target");
      var alertCount = $("a.dropdown-toggle span.alert-badge").text();
      $('.content-row:visible', '.user-alerts').not(target).hide();
      $(target).toggle(200);

      if(alertRow.attr("data-read-status") === 'unread'){
        var url = alertRow.attr("data-service-url");
        $.ajax({
          type: 'POST',
          url: url,
          success: function(data) {
            if(data.status == 'success') {
              alertRow.find(".alert-image").attr('src', '/images/glyphicons_121_message_empty.png');
              alertRow.attr("data-read-status", "read");
              $("a.dropdown-toggle span.alert-badge").text(alertCount-1);
            }
          }
        });
      }
    });

    $('.user-alerts').on('click', '.alert-content .archive', function(e) {
      e.preventDefault();
      var alertContent = $(this).closest('.alert-content');

      var activePage = $('.pagination li.active a', '.user-alerts'),
          pageNumber = 1, matches = null;

      if(activePage.length > 0) {
        matches = activePage.attr('href').match(/=(\d+)$/);
        pageNumber = matches[1];

        if(pageNumber > 1 && $('.user-alerts .alert-row').length == 1)
          pageNumber--;
      }

      $.ajax({
        url: $(this).attr('href'), type: 'POST', data: {'page': pageNumber},
        beforeSend: function() {
          alertContent.find('.archive').hide();
          alertContent.find('.loader').show();
        }
      });
    });
  }
});

/** utility methods **/
function isValidEmail(email) {
    var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    return email_regex.test(email.trim());
}

function isValidMobile(phone){
    var phone_regex = /^[1-9]\d{9}$/;
    return phone_regex.test(phone.trim());
}

function send_email_invites(email_list, token, url) {
  $.ajax({
    type: 'POST',
    url: url,
    data: {
      email_list: email_list,
      authenticity_token: token
    },
    success: function(data) {
      if (data === 'success') {
        $('.notice-area').html("<div class='alert alert-success'>Thanks! Your invite was successfully sent.</div>");
        alertInfo();
      }
    }
  });
}

function alertInfo() {
  $('.notice-area').hide();
  setTimeout(showFlashMessages, 500);
  setTimeout(hideFlashMessages, 3500);
}

function hideFlashMessages() {
    $('.alert').slideUp(200);
}

function showFlashMessages() {
  $('.notice-area').slideDown(200);
}


// Facebook app response handler
function requestCallback(response) {
    if(response){
        $('.notice-area').html("<div class='alert alert-success'>Thanks! Your invite was successfully sent.</div>");
        alertInfo();
    }
}

 var facebookInviteFriends = function(){
     $("a#invite_fb_friends").click(function() {
        FB.init({
           appId:'218915071554448',
           cookie:false,
           status:false
        });

        FB.ui({ method: 'apprequests', message: $(this).attr('data-data') + ' invites you to OnTheWay. It is a service that helps folks who want to share rides contact each other and mutually arrange for traveling together.'}, requestCallback);
      });
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

function rideTime(){
    $('input.timepicker').timepicker({
        timeFormat: 'h:mm p',
        interval: 30,
        blur: function(time) {

            alert($.fn.timepicker.parseTime('h:mm p',time));
           
        }
    });
}

function rideDate(){
    $( "input.datepicker" ).datepicker({
        nextText: '',
        prevText: '',
        dateFormat: 'dd-mm-yy',
        minDate: new Date
    });
}

function rideOriginDest(){
    $("#ride_request_orig").live("change",function(){
        $("#ride_request_dest").val("");
    });
}

function typeaheadSearch(){
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

function initSearchResultsPopovers() {
  $('.result-popover', '.search-results').popover({
      title: 'Please note'
  });
}

function initDeleteRidePopovers() {
  $(".ride-list .delete-ride-cell .disabled").popover({title: "Please note"});
}

function rideOfferSearch(){
    $('.rideOffer').typeahead({
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
        },
       itemSelected: function(ele, val, text) {
            var url = $("#ride_offer_url").val()
            var ride_time = $("#ride_time").val()
            var vehicle = $("#vehicle").val()
            var ride_orig
            var ride_dest
            if($(ele).attr('id') == 'ride_orig'){
               ride_orig = text
               ride_dest = $('#ride_dest').val();
            }
            else if($(ele).attr('id') == 'ride_dest'){
               ride_orig = $('#ride_orig').val();
               ride_dest = text
            }
            rideOffersList(url,{ride_time: ride_time, vehicle: vehicle, orig: ride_orig, dest: ride_dest});
        }
    });
}

var rideOffersList =  function(url, dataArray){
         $.ajax({
                  type: 'GET', data: dataArray,
                  dataType: 'script',
                  url: url
              });
     }

