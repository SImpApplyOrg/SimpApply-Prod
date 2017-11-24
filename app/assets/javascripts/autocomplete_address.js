function initAutocomplete() {
  var input = document.getElementById('user_address');
  
  new google.maps.places.Autocomplete(input);
}
