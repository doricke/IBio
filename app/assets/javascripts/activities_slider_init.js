
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

//returns the index of coordinates array with time that is below and closest to the targetTime
function timeSearch(lo, hi){
    var mid = Math.floor((lo+hi)/2);
    if(lo===mid){
        return lo;
    }
    if(gon.data.Time[mid] >= targetTime){
        return timeSearch(lo, mid-1);
    }else{
        return timeSearch(mid, hi);
    }
}

//given the time that the offset is taken at
//if given targetTime == beginTime => offset == 0 (start)
//if given targetTime == endTime   => offset == 100 (finish)
//and all values in between
//pointLocI = recorded location/time immediately before targetTime
//pointLocJ = recorded location/time immediately after targetTime
function getOffsetPercentage(){
    //the index of the latest time prior to the targetTime
    var i = timeSearch(0, gon.data.coordinates.length);

    //gets the offset % at the last marked location
    var partialLine = new google.maps.Polyline({
        path: gon.data.coordinates.slice(0, i+1),
        geodesic: true
    });

    //length of the path from origin to last marked location
    var dist0toI = google.maps.geometry.spherical.computeLength(partialLine.getPath());

    //pointLoc0 = recorded location/time at beginning of journey
    var beginTime = gon.data.Time[0];

    //assumes constant speed between last recorded location and the next recorded location
    var iTime = gon.data.Time[i];
    var jTime = gon.data.Time[i+1];

    //timespan between pointLocI and pointLocJ
    var spanTime = jTime - iTime;

    //interpolated time to get from point_n and targetPoint
    var interpTime = targetTime.getTime() - iTime;

    //percentage of distance travelled between point i and j assuming constant speed
    var interpPercentage = interpTime/spanTime;


    //calculates the amount of distance travelled from i to target
    var distItoJ = google.maps.geometry.spherical.computeDistanceBetween(
        gon.data.coordinates[i], gon.data.coordinates[i+1]
    );

    //calculates the percentage travelled by the interpPercentage
    var distItoTarget = distItoJ * interpPercentage;

    //total distance travelled from start to target
    var targetDist = dist0toI + distItoTarget;

    return (targetDist / gon.data.pathLength)*100;
}

// moves the map marker to correspond to the provided time
function moveMapMarker() {
    var offset = getOffsetPercentage(targetTime);

    var icons = gon.data.line.get('icons');
    icons[0].offset = offset + '%';
    gon.data.line.set('icons', icons);
}

function moveSlider(elapsedSeconds){
    $('#time').text(targetTime.toLocaleString());
    moveMapMarker(targetTime);

    //changes the button depending on state
    //if at value is at end, stop animation and set to repeat option
    if(elapsedSeconds == slider.slider('option', 'max')){
        timeCtrlImg.addClass('glyphicon-repeat');
        timeCtrlImg.removeClass('glyphicon-play glyphicon-pause');
        isAnimating = false;
    //if there slider is paused and moved to the middle
    }else if (!isAnimating){
        timeCtrlImg.addClass('glyphicon-play');
        timeCtrlImg.removeClass('glyphicon-repeat');
    }
}

function sliderResponse(event, ui){
    targetTime = new Date(gon.data.Time[0] + ui.value*1000);
    moveSlider(ui.value);
    moveLine();
}

function sliderInit(){
    //elapsedTime = amount of seconds between endTime and startTime
    var elapsedTime = Math.floor((gon.data.Time[gon.data.Time.length - 1]-gon.data.Time[0])/1000);
    slider.slider({
        max: elapsedTime,
        change: sliderResponse,
        slide: sliderResponse
    });
    //sets the initial time for the slider
    $('#time').text(new Date(gon.data.Time[0]).toLocaleString());
}

//animates a single tick of the animation, increases the time by the given arg (in number of seconds)
function animateTick(timeIncrementVal){
    if(slider.slider("value") == slider.slider("option", "max")){
        isAnimating = false;
    }else{
        var sValue = slider.slider('value');
        slider.slider("value", sValue + timeIncrementVal);
    }
}

//automatically adjusts slider value and map continually until isAnimating is set to false
function sliderAnimate(){
    if(isAnimating) {
        //timeIncrementVal is the number of seconds to increment the slider by
        var timeIncrementVal = 9 * speed + 1
        animateTick(timeIncrementVal);
        setTimeout(sliderAnimate, 30);
    }

}

//play pause repeat button all in one
function timeCtrlBtnInit(){
    $('#timeCtrlBtn').click(function(){
        if(timeCtrlImg.hasClass('glyphicon-play')){
            timeCtrlImg.toggleClass('glyphicon-play glyphicon-pause');
            isAnimating = true;
            sliderAnimate();
        } else if (timeCtrlImg.hasClass('glyphicon-pause')){
            timeCtrlImg.toggleClass('glyphicon-play glyphicon-pause');
            isAnimating = false;
        } else if (timeCtrlImg.hasClass('glyphicon-repeat')){
            timeCtrlImg.removeClass('glyphicon-repeat');
            slider.slider('value', 0);
            isAnimating = true;
            sliderAnimate();
        }
    });
}

// creates the speed slider
// boilerplate code mostly copied from jquery-cookbook, chapter 13
function speedSliderInit() {
    $('#speed')
        .slider({
            max: 1,
            orientation: 'vertical',
            range: 'min',
            step: 0.01,
            value: speed,
            start: function(event, ui) {
                $(this)
                    .parents('.ui-slider')
                    .css({
                        'margin-top': (((1 - speed) * -100) + 5) + 'px',
                        'height': '100px'
                    })
                    .find('.ui-slider-range')
                    .show();
            },
            slide: function(event, ui) {
                if (ui.value >= 0 && ui.value <= 1) {
                    speed = ui.value;
                }
                $(this)
                    .css({
                        'margin-top': (((1 - speed) * -100) + 5) + 'px',
                        'height': '100px'
                    })
                    .find('.ui-slider-range')
                    .show();
            },
            stop: function(event, ui) {
                var overHandle = $(event.originalEvent.target).closest('.ui-slider-handle').length > 0;
                if (!overHandle) {
                    $(this)
                        .css({
                            'margin-top': '',
                            'height': ''
                        })
                        .find('.ui-slider-range')
                        .hide();
                }
            },
            change: function(event, ui) {
                if (ui.value >= 0 && ui.value <= 1 && ui.value != speed) {
                    speed = ui.value;
                }
            }
        })
        .mouseenter(function(event) {
            if ($('.ui-slider-handle.ui-state-active').length) {
                return;
            }
            $(this)
                .css({
                    'margin-top': (((1 - speed) * -100) + 5) + 'px',
                    'height': '100px'
                })
                .find('.ui-slider-range')
                .show();
        })
        .mouseleave(function() {
            $(this)
                .css({
                    'margin-top': '',
                    'height': ''
                })
                .find('.ui-slider-range')
                .hide();
        })
        .dblclick(function(){
            $(this)
                .slider('value', 0.5)
                .css({
                    'margin-top': (((1 - speed) * -100) + 5) + 'px',
                    'height': '100px'
                })
                .find('.ui-slider-range')
                .show();
        })
        .find('.ui-slider-range')
        .hide()
        .end();
}


$(function(){
    sliderInit();
    timeCtrlBtnInit();
    speedSliderInit();
});
