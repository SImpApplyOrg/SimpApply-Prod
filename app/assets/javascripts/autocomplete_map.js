// This example requires the Places library. Include the libraries=places
// parameter when you first load the API. For example:
// <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">

function initMap() {
  // var pos = { lat: 37.09024, lng: -95.71289100000001 }
  // map_dom = document.getElementById('map')
  input = document.getElementById('user_address');

  // map = new google.maps.Map(map_dom, {
  //   center: pos,
  //   zoom: 4
  // });

  // geocoder = new google.maps.Geocoder();

  var autocomplete = new google.maps.places.Autocomplete(input);

  // Bind the map's bounds (viewport) property to the autocomplete object,
  // so that the autocomplete requests use the current map bounds for the
  // bounds option in the request.
  // autocomplete.bindTo('bounds', map);

  // marker = new google.maps.Marker({
  //   map: map,
  //   anchorPoint: new google.maps.Point(0, -29),
  //   draggable: true,
  //   flat: false
  // });

  // if (map_dom.getAttribute('data-lat-lng-present') == 'true') {
  //   pos = {
  //     lat: parseFloat($('#user_lat').val()),
  //     lng: parseFloat($('#user_lng').val())
  //   };
  //   setPosition(pos);
  // }

  autocomplete.addListener('place_changed', function() {
    // marker.setVisible(false);
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      // User entered the name of a Place that was not suggested and
      // pressed the Enter key, or the Place Details request failed.
      window.alert("No details available for input: '" + place.name + "'");
      return;
    }

    // If the place has a geometry, then present it on a map.
    // map.setCenter(place.geometry.location);
    // map.setZoom(17);  // Why 17? Because it looks good.

    // marker.setPosition(place.geometry.location);
    // marker.setVisible(true);

    set_lat_lng(place.geometry.location)
  });

  // google.maps.event.addListener(marker, 'dragend', function() {
  //   geocodeAddressByLatLng(marker.getPosition());
  // });
}

function set_lat_lng(pos) {
  $('#user_lat').val(pos.lat());
  $('#user_lng').val(pos.lng());
}

// function setPosition(pos) {
//   map.setCenter(pos);
//   map.setZoom(17);  // Why 17? Because it looks good.

//   marker.setPosition(pos);
// }

// function geocodeAddressByLatLng(pos) {
//   geocoder.geocode({
//     latLng: pos
//   }, function(responses) {
//     if (responses && responses.length > 0) {
//       marker.formatted_address = responses[0].formatted_address;
//     } else {
//       marker.formatted_address = 'Cannot determine address at this location.';
//     }
//     input.value = marker.formatted_address
//     set_lat_lng(pos)
//   });
// }
