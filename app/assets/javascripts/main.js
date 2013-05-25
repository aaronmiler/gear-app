$('body').on('blur','#location',function(){
	if($(this).val() != ''){
		$("#submit-btn").removeAttr('disabled')
	}
	else {
		$("#submit-btn").attr('disabled','disabled')
	}
})
$("[data-behaviour~='datepicker']").datepicker({
    "format": "yyyy-mm-dd",
    "weekStart": 1,
    "autoclose": true
});
var time = 1;
$('body').on('click','#addTime',function(){
	$("#time_list").append('<div class="time"> <select class="pull-left" id="time_0__h_" name="times['+time+'][h]"><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option><option>6</option><option>7</option><option>8</option><option>9</option><option>10</option><option>11</option><option>12</option></select> <select class="pull-right" id="time_0__ampm_" name="times['+time+'][ampm]"><option>AM</option><option>PM</option></select> <div class="clear-fix"></div> </div>') 
	time ++
})