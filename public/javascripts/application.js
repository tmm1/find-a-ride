// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  initCBSwitch();
  AutoSearchLocation();
  initRideSearch();
  initOverlays();
});

var initOverlays = function() {
   $('.overlay_link').overlay({
    mask: 'darkred',
    effect: 'apple'
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
            $('#search_results_block').fadeIn(400);
            initPaginationLinks();
            initOverlays();
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
            $('#search_results_block').fadeIn(400);
            initOverlays();
            initPaginationLinks();
		  },
		  failure: function(data) {
		  }
		});
	});
}

var AutoSearchLocation = function(){
  var url = $('#data-url').val();
  var elem = $("input.autocomplete");
  elem.unautocomplete();
  elem.autocomplete(url,{
    dataType: 'json',
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