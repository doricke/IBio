
// ###############################################################################
//  Copyright (C) 2015 Nelson Chiu 
//  Author::    	Nelson Chiu
//  Copyright:: 	Copyright (c) 2014 MIT Lincoln Laboratory
//  License::   	GNU GPL license  (http://www.gnu.org/licenses/gpl.html)
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
// ###############################################################################

function findCorners(coordinates){
    var north = south = coordinates[0].lat();
    var east = west = coordinates[0].lng();
    //finds max north/south/west/east coordinates across the entire array
    for(var i in coordinates){
        var coord = coordinates[i];
        north = coord.lat() > north ? coord.lat() : north;
        south = coord.lat() < south ? coord.lat() : south;
        west = coord.lng() < west ? coord.lng() : west;
        east = coord.lng() > east ? coord.lng() : east;
    }

    var cornerNE = new google.maps.LatLng(north, east);
    var cornerSW = new google.maps.LatLng(south, west);

    return [cornerNE, cornerSW];
}

function mapInit() {
    gon.data.coordinates = [];
    for(var i in gon.data['Latitude (deg)']){
        gon.data.coordinates.push(
            new google.maps.LatLng(gon.data['Latitude (deg)'][i], gon.data['Longitude (deg)'][i]
            ));
    }

    var mapCorners = findCorners(gon.data.coordinates);
    var mapOptions = {
        mapTypeId: google.maps.MapTypeId.TERRAIN
    };

    var map = new google.maps.Map(document.getElementById('map-canvas'),
        mapOptions);

    //dynamically sets the map bounds
    var bounds = new google.maps.LatLngBounds();
    bounds.extend(mapCorners[0]);
    bounds.extend(mapCorners[1]);
    map.fitBounds(bounds);


    var linePath = new google.maps.Polyline({
        path: gon.data.coordinates,
        geodesic: true
    });

    linePath.setMap(map);

    // Define the symbol, using one of the predefined paths ('CIRCLE')
    // supplied by the Google Maps JavaScript API.
    var lineSymbol = {
        path: google.maps.SymbolPath.CIRCLE,
        scale: 8,
        strokeColor: 'green',
        strokeWeight: 4
    };

    // Create the polyline and add the symbol to it via the 'icons' property.
    gon.data.line = new google.maps.Polyline({
        path: gon.data.coordinates,
        icons: [{
            icon: lineSymbol,
            offset: '0%'
        }],
        map: map
    });

    gon.data.pathLength = google.maps.geometry.spherical.computeLength(gon.data.line.getPath());
}

$(function(){
    mapInit();
});
