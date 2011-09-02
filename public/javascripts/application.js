// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
  AutoSearchLocation();
  $("a[rel]").overlay({
    mask: 'darkred',
    effect: 'apple'
  });
});

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