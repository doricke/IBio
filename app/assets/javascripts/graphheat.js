
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
//= require highcharts/modules/heatmap

$(function () {

    $('#container').highcharts({

        chart: {
            type: 'heatmap',
            marginTop: 40,
            marginBottom: 40
        },


        title: {
            text: 'Data Heatmap'
        },

        xAxis: {
            categories: gon.x_axis
        },

        yAxis: {
            categories: gon.y_axis,
            title: null
        },

        colorAxis: {
            min: 0,
            minColor: '#FFFFFF',
            maxColor: '#FF0000 '
        },

        legend: {
            align: 'right',
            layout: 'vertical',
            margin: 0,
            verticalAlign: 'top',
            y: 25,
            symbolHeight: 320
        },

        tooltip: {
            formatter: function () {
                return 'Recorded <b>' +
                    this.point.value + '</b> on <br><b>' + this.series.yAxis.categories[this.point.y] +  ' </b>at<b> ' + this.series.xAxis.categories[this.point.x] + '</b>';
            }
        },

        series: [{
            name: 'Data Heatmap',
            borderWidth: 1,
            data: gon.data,
            dataLabels: {
                enabled: true,
                color: 'black',
                style: {
                    textShadow: 'none'
                }
            }
        }]

    });
});

