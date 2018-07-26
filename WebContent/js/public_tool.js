var host = "http://123.206.8.125:5000"

var start_year = 2005;
var myDate = new Date();
var end_year = myDate.getFullYear();

var current_user = {};

$.ajax({
    type:'GET',
    url:host+'/user/current_user',
    data: {},
    xhrFields: {
        withCredentials: true
    },
    crossDomain: true,
    async: false ,
    success: function (resp) {
        current_user = resp.data[0];
        $("#curent_user_detail").text( resp.data[0].username)
    }.bind(this)
})
