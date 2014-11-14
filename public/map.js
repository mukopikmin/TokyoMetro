function initialize(lat, lng) {
    /*----- ‰¼‚ÌˆÊ’u‚ð’è‹` -----*/
    var latlng = new google.maps.LatLng(lat, lng);
 
    /*----- ƒx[ƒXƒ}ƒbƒv‚ÌƒIƒvƒVƒ‡ƒ“’è‹` -----*/
    var myOptions = {
        zoom: 16,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
 
    /*----- ƒ}ƒbƒv‚Ì•`‰æ -----*/
    var map = new google.maps.Map(document.getElementById('map_basic'), myOptions);
 
    /*----- ƒAƒCƒRƒ“‚ÌƒIƒvƒVƒ‡ƒ“’è‹` -----*/
    var markerOptions = {
        position: latlng,
        map: map,
        title: ''
    };
 
    /*----- ƒ}[ƒJ[•`‰æ -----*/
    var marker = new google.maps.Marker(markerOptions);
 
    /*----- ƒWƒIƒR[ƒfƒBƒ“ƒO‚ð’è‹` -----*/
    var geocoder = new google.maps.Geocoder();
 
    /*----- ƒWƒIƒR[ƒfƒBƒ“ƒO‚ðŽÀs -----*/
    // geocoder.geocode({
    //     'address':'名古屋市'
    // },function(results, status){
    //     if (status == google.maps.GeocoderStatus.OK) {
    //         map.setCenter(results[0].geometry.location);
    //         marker.setPosition(results[0].geometry.location);
    //     }
    // });
}