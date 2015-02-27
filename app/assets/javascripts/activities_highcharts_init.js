
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

//zips up two arrays in an array
//zip([[1,2],[11,22],[111,222]])
//[1,11,111],[2,22,222]]]
function zip(arrays) {
    return arrays[0].map(
        function(_,i){
            return arrays.map(
                function(array){
                    return array[i]
                });
        });
}

function moveLine(){
    var offset = highchart.xAxis[0].toPixels(targetTime, true);
    if( offset >= 0 && offset <= highchart.plotWidth) {
        highchartLine.translate(offset).show();
    } else {
        highchartLine.hide();
    }
}

function chartClick(event){
    var targetMS;
    if (event.point){
        targetMS = event.point.x
    } else if (event.xAxis[0]){
        targetMS = event.xAxis[0].value
    }

    slider.slider('value', Math.round(targetMS/1000) - gon.data.Time[0]/1000);
}

function highchartInit(){
    //highcharts options
    Highcharts.setOptions({
        global: {
            useUTC: false
        }
    });

    new Highcharts.StockChart({
            chart: {
                renderTo: 'highchartsContainer',
                events: {
                    redraw: moveLine,
                    click: chartClick
                }
            },
            xAxis: {
                ordinal: false,
                title: {
                    text: 'Time'
                },
                plotLines: [{
                    value: gon.data.Time[0],
                    width: 10,
                    color: 'black'
                }],
                floor: gon.data.Time[0],
                ceiling: gon.data.Time[gon.data.Time.length - 1],
                minTickInterval: 1000
            },

            yAxis: [
                {
                    min: 0,
                    ordinal: false,
                    plotLines: [{
                        value: 0,
                        width: 2,
                        color: 'silver'
                    }],
                    title: {
                        text: 'Speed (m/s)'
                    }
                },{
                    min: 0,
                    ordinal: false,
                    opposite: true,
                    title: {
                        text: 'Altitude'
                    }
                }
            ],

            navigator: {
                baseSeries: 0, //default,
                series: {color: 'black'}
            },

            tooltip: {
                crosshairs: [{
                    color: 'black',
                    dashStyle: 'Dot',
                    width: 1
                }],
                pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b><br/>',
                valueDecimals: 2
            },

            plotOptions: {
                series: {
                    events: {
                        click: chartClick
                    }
                }
            },

            series: [
                {
                    name: 'Speed (m/s)',
                    data: zip([ gon.data["Time"], gon.data["Speed (m/s)"] ]),
                    type: 'spline',
                    color: Highcharts.getOptions().colors[5]

                },{
                    name: 'Altitude',
                    data: zip([ gon.data["Time"], gon.data["Altitude"] ]),
                    type: 'spline',
                    yAxis: 1,
                    color: Highcharts.getOptions().colors[6]
                }
            ]
        },
        function(){
            function moveLineManually(event){
                $(document).bind({
                    'mousemove.highchartLine': step,
                    'mouseup.line': stop
                });

                var clickX = event.pageX - highchartLine.translateX;

                function step(event){
                    highchartLine.translate(event.pageX - clickX, 0);
                    var targetMS = highchart.xAxis[0].toValue(event.pageX - clickX, true);
                    slider.slider('value', Math.round(targetMS/1000) - gon.data.Time[0]/1000);
                }

                function stop(){
                    $(document).unbind('.highchartLine');
                }
            }

            highchart = this;
            highchartLine = this.xAxis[0].plotLinesAndBands[0]
                .svgElem.css({
                    'cursor': 'pointer'
                }).on('mousedown', moveLineManually);

            targetTime = gon.data.Time[0];
        }
    );
}

$(function(){
    highchartInit();
});
