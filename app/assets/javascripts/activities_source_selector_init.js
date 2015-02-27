
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

function airchartsInit(){
    //number of hours before and after the non air data start/end time
    var timeDifference = 12;

    airchart = new Highcharts.StockChart({
        chart: {
            renderTo: 'airchartsContainer'
        },
        xAxis: {
            ordinal: false,
            title: {
                text: 'Time'
            },
            //highlights the period of time covered by gon.data
            plotBands: [
                {
                    color: '#4572A7',
                    from: gon.data.Time[0],
                    to: gon.data.Time[gon.data.Time.length-1]
                }
            ],
            min: gon.data.Time[0]-(1000 * 60 * 60 * timeDifference),
            max: gon.data.Time[gon.data.Time.length-1]+(1000 * 60 * 60 * timeDifference)
        },
        //change the range of the y axis
        yAxis: {
            title: {
                text: 'Air Data'
            },
            opposite: true,
            // type: 'logarithmic',
            min: 0,
            max: 10
        },
        navigator: {
            enabled: false
        },
        scrollbar: {
            enabled: false
        },
        rangeSelector: {
            enabled: false
        }
    });
}

//initializes the dropdown source selector to respond to changes
function sourceSelectorInit(){
    $("#sourceSelector").change(
        function(){
            //removes old series data from last source
            while(airchart.series.length > 0) {
                airchart.series[0].remove(false);
            }

            //key is currently selected place_id
            var key = $(this).val();
            //data pertaining to the selected station
            var relevantData = gon.data.air[key][Object.keys(gon.data.air[key])];

            //adds the new series
            $.each(relevantData, function(k, v){
                airchart.addSeries({
                    name: k,
                    data: v
                }, false);
            });

            //redraw the chart
            airchart.redraw();
        }).change();
}

$(function(){
    airchartsInit();
    sourceSelectorInit();
});
