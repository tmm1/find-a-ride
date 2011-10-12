$(document).ready(function() {
  initCBSwitch();
  AutoSearchLocation();
  initRideSearch();
  initOverlays();
  initInactiveOverlay();
  initConfirmBtns();
});


var isValidEmail = function(email) {
   var email_regex = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
   if(email_regex.test(email) == false) {
      return false;
   }
}

var initOverlays = function() {
   $('.overlay_link').overlay({
    mask: { color: '#eff2f7', loadSpeed: 100, opacity: 0.7 },
    effect: 'apple',
    closeOnClick: false
   });		
}

var initInactiveOverlay = function() {
    $('.inactive_input').overlay({
	  mask: { color: '#eff2f7', loadSpeed: 100, opacity: 0.7 },
      closeOnClick: false
    });
}

var initConfirmBtns = function(){
  $('#user_inactive').live('click', function(){
    $('.confirm_dialog').show();
    checked = ($('.inactive_input').attr('checked'));
  });

  $('#confirm_yes').live('click', function(){
    if (checked == 'checked'){
      $('.inactive_input').attr('checked', true);
    }
    else{
      $('.inactive_input').attr('checked', false);
    }
    $('.confirm_dialog').hide();
    $('.inactive_input').overlay().close();
    return false;
  });

  $('#confirm_no').live('click', function(){
    if (checked == 'checked'){
      $('.inactive_input').attr('checked', false);
    }
    else{
      $('.inactive_input').attr('checked', true);
    }
    $('.confirm_dialog').hide();
    $('.inactive_input').overlay().close();
    return false;
  });
}

var initCBSwitch = function() {
	$('#search_get_ride').hide();
	$('#search_offer_ride').hide();
	$(".cb-enable").click(function(){
		var parent = $(this).parents('.switch');
		$('.cb-disable',parent).removeClass('selected');
		$(this).addClass('selected');
		$('.checkbox',parent).attr('checked', true);
	});
	$(".cb-disable").click(function(){
		var parent = $(this).parents('.switch');
		$('.cb-enable',parent).removeClass('selected');
		$(this).addClass('selected');
		$('.checkbox',parent).attr('checked', false);
	});	
};

var initRideSearch = function() {
  var search_url = $('#search_rides').attr('search_url');
  $('#search_rides').click(function() {
	 var origin = $('#search_origin').val();
	 var dest = $('#search_destination').val();	 
	 var matcher = '';
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
		  data: {origin: origin, dest: dest, matcher: matcher},	
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
  $('.form_wrapper').find('.submit_button').click(function() {
	form_div = $(this).closest('.form_wrapper');
    var name = form_div.find('#contact_name').val();
    var email = form_div.find('#contact_email').val();	
    if (name == '' || email == '') {
	   form_div.find('.form_error').html('<h3>Need both name and email!</h3>');
	   form_div.find('.form_error').fadeIn(400);
	}
	else if (!isValidEmail(email)) {
	   form_div.find('.form_error').html('<h3>Need a valid email!</h3>');
	   form_div.find('.form_error').fadeIn(400);
	}
	else {
	   form_div.find('.form_error').hide();
	}
  });
}

var resetContactForm = function() {
	$('.form_wrapper').each(function (){
	  $(this).find('.form_error').hide();
	  $(this).find('#contact_name').val('');
	  $(this).find('#contact_email').val('');	
	  $(this).find('#contact_phone').val('');		
	  $(this).find('#contact_msg').val('');	
	});
}

var AutoSearchLocation = function(){
  var url = $('#data-url').val();
  var elem = $("input.autocomplete");
  elem.unautocomplete();
  elem.autocomplete(url,{
    dataType: 'json',
    extraParams: {city: $("#city_select").val()},
    delay :200,
    scroll: true,
    scrollHeight: 300,
    parse: function(data) {
      var array = new Array();
      for(var i=0; i<data.length; i++)
      {
        array[array.length] = {data: data[i], value: data[i],result:data[i]};
      }
      return array;
    },
    formatItem: function(row) {
      return row;
    }
  });
}
