// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  initCBSwitch();
  AutoSearchLocation();
  initRideSearch();
  $("a[rel]").overlay({
    mask: 'darkred',
    effect: 'apple'
  });
});

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
}

var initRideSearch = function() {
  var search_url = $('#search_rides').attr('search_url');
  $('#search_rides').click(function() {
	 var origin = $('#search_origin').val();
	 var destination = $('#search_destination').val();	 
	 if (origin == '' || destination == '') {
		$('#search_error').fadeIn(400);
	 }
	 else { $('#search_error').hide(); }
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