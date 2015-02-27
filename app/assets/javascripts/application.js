//= require jquery
//  require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete-rails
//  require jquery-fileupload
//  require jquery-fileupload/basic
//  require jquery-fileupload/vendor/tmpl
//= require dataTables/jquery.dataTables
//  require turbolinks
//= require fullcalendar
//= require openlayers-rails
//= require local_time


function dataTablesInit(){
    $('.dataTable').dataTable({
        "bJQueryUI": true,
        "pagingType": "full_numbers"
    });
}

$(function(){
    dataTablesInit();
});
