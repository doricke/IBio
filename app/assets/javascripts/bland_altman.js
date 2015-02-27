
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

//= require highcharts

function blandAltmanChartInit() {

    function populateChart(dataStruct, key, id){
        var avg     = dataStruct[key]['avg'];
        var stdDev  = dataStruct[key]['stdDev'];
        var pearson = dataStruct[key]['pearson'];

        $("#" + id).highcharts({
                chart: {
                    type: 'scatter',
                    zoomType: 'xy'
                },
                title: {
                    text: key + '<br>Bland-Altman Plot'
                },
                legend: {
                    enabled: false
                },
                tooltip: {
                    formatter: function () {
                        return '<b>Mean</b>: ' + this.x +
                            '<br><b>Difference: </b>' + this.y +
                            '<br><b>Date range: </b>' + this.point.date_range;
                    }
                },
                xAxis: {
                    title: {
                        enabled: true,
                        text: 'Mean'
                    },
                    min: 2,
                    max: 10
                },
                yAxis: {
                    title: {
                        text: key.replace("vs", "-")
                    },
                    min: -8,
                    max: 8,
                    plotLines: [
                        {
                            color: 'red',
                            width: 2,
                            value: avg + stdDev,
                            label: {
                                style: {
                                    fontFamily: 'Lucida Console'
                                },
                                align: 'right',
                                text: "+1 SD: " + (avg + stdDev).toFixed(2)
                            }
                        },
                        {
                            color: 'red',
                            width: 2,
                            value: avg - stdDev,
                            label: {
                                style: {
                                    fontFamily: 'Lucida Console'
                                },
                                align: 'right',
                                text: "-1 SD: " + (avg - stdDev).toFixed(2)
                            }
                        },
                        {
                            color: 'black',
                            width: 2,
                            value: avg,
                            label: {
                                style: {
                                    fontFamily: 'Lucida Console'
                                },
                                align: 'right',
                                text: "Mean: " + (avg).toFixed(2)
                            }
                        }
                    ]
                },
                plotOptions: {
                    scatter: {
                        states: {
                            hover: {
                                marker: {
                                    enabled: false
                                }
                            }
                        }
                    }
                },
                series: [{
                    data: dataStruct[key]['series'],
                    turboThreshold: 0
                }]
            },
            function(chart){
                chart.renderer.text('Standard Deviation: ' + stdDev.toFixed(2) +
                    '<br>Pearson\'s r: ' + pearson.toFixed(2), 675, 335)
                    .css({
                        color: '#4572A7',
                        fontSize: '10px'
                    })
                    .add();;
            });
    }

    function makeChart(dataStruct, key){
        var id = key.replace(/ /g, "-");
        var chartDiv = document.createElement("div");
        $(chartDiv).attr("id", id);
        chartDiv.style.cssText = "min-width: 310px; height: 400px; max-width: 800px; margin: 0 auto";
        $("#highcharts").append(chartDiv);
        $("#" + id).after("<hr>");
        populateChart(dataStruct, key, id);
    }

    $.each(gon.data, function(key, value){
        makeChart(gon.data, key);
    });
}

$(
    blandAltmanChartInit
);
