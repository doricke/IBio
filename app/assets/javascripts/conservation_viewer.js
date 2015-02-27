
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

//= require chroma.min
var selectedResidues = {};

//initializes the colors of the residues
function initColors(){
    //initializes the default color to grey
    Jmol.script(jmolApplet0,'select all;color grey;');
    //colors residues that have an associated color
    //residues such as 188A will be ignored
    $.each(gon.residues, function(i, val) {
        Jmol.script(jmolApplet0,'select '+ val[0] +';color ' + colorMap(val[1]) + ';');
    });
}

//initializes the slider with a callback function to hide/unhide the residues within the slider range
function initSlider() {
    //$("#ex2").slider({});
    //$(".conservationRange").slider({});
    var slider = $("#conservation-slider");
    var initMin=-20, initMax=99;
    slider.slider({
        range: true,
        min: initMin,
        max: initMax,
        values: [ initMin, initMax ],
        create: sliderMove,
        stop: sliderMove

    });
    //updates status of min/max slider values
    function sliderMove(){
        sMin = slider.slider( "values", 0 );
        sMax = slider.slider( "values", 1 );
        displayAndHide(sMin, sMax);
        $("#conservation-slider .ui-slider-handle").first().text(sMin);
        $("#conservation-slider .ui-slider-handle").last().text(sMax);
    }
}

//hides or shows protein stuctures if their conservation level is within the slider range
function displayAndHide(sMin, sMax){
    var hideList = [];
    $.each(gon.residues, function(i, val) {
        //hide if outside slider range
        if(val[1] < sMin || val[1] > sMax ){
            hideList.push(val[0]);
        }
    });
    Jmol.script(jmolApplet0, 'hide ' + hideList.toString() + ';' );
}

//determines the color that is associated with the input conservation level
// RANGE -20 Dark Green to 0 Green
// STOP  1 Red
// RANGE 2 Purple to 99 Blue
function colorMap(cLevel){
    var posScale = chroma.scale(['purple', 'aqua']);
    var negScale = chroma.scale(['lawngreen', 'darkgreen']);
    if(cLevel <= 0) {
        return '[' + negScale(-cLevel/20).rgb().toString() + ']';
    }else if (cLevel == 1) {
        return "red";
    }else if (cLevel >= 2){
        return '[' + posScale((cLevel-1)/99).rgb().toString() + ']';
    }else{
        //UNKNOWN case, should not happen
        return 'brown'
    }
}

//unobtrusive javascript function to toggle color residue clicking
function initResidueClicks(){
    $("a[data-residue]").click(function (e){
        e.preventDefault();
        var residue = $(this).data("residue");

        if(residue in selectedResidues){
            Jmol.script(jmolApplet0, 'select ' + residue + ';color ' + selectedResidues[residue] + ';');
            delete selectedResidues[residue];
        }else{
            var conservationColor = colorMap($(this).data("conservation"));
            Jmol.script(jmolApplet0, 'select ' + residue + ';color orange');
            selectedResidues[residue] = conservationColor;
        }
    });
}

$(function(){
    initColors();
    initSlider();
    initResidueClicks();
});
