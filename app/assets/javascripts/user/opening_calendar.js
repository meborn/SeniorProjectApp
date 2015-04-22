var openingBuildCalendarView = function(profile_id, calendar) {
	
	// $('#calendar_body').empty();
	// $.each(calendar, function(w, week) {
	// 	console.log('week index' + w);
	// 	$('#calendar_body').append("<tr id='week_"+w+"'></tr>");
	// 	$.each(week,function(d, day) {
	// 		$('#week_'+w).append("<td id='"+day.year+"_"+day.month+"_"+day.date+"'><p class='"+day.status+"'>"+day.date+"</p></td>");
	// 		$.each(day.events, function(i, e) {
	// 			$("#"+day.year+"_"+day.month+"_"+day.date).append("<div class='event_marker event_profile_"+e.profile_id+"'></div>");

	// 		});
	// 	});
	// });
	var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	var days = ["Sunday", "Monday", "Tuesday","Wednesday","Thursday","Friday","Saturday"];
	
	$('#calendar_body').empty();
	$.each(calendar, function(w, week) {
		console.log('week index' + w);
		var week_event_count = 0;
		$('#calendar_body').append("<div class='ninja_panel panel panel-default' id='week_"+w+"_container'><div class='panel-heading' role='tab' id='week_"+w+"_heading'></div></div>");
		$('#week_'+w+'_heading').append("<h2 class='panel-title'><a class='collapsed sans_serif_bold' data-toggle='collapse' data-parent='#calendar_body' href='#week_"+w+"_content' aria-expanded='false' aria-controls='week_"+w+"_content'>"+(week[0].month+1)+"/"+week[0].date+" - "+(week[6].month+1)+"/"+week[6].date+"</a></h2>");
		$('#week_'+w+'_container').append("<div id='week_"+w+"_content' class='panel-collapse collapse' role='tabpanel' aria-labelledby='week_"+w+"_heading'><ul class='list-group'></ul></div>");
		$.each(week, function(d, day) {
			$('#week_'+w+'_content ul').append("<li class='list-group-item c-item' id='"+day.year+"_"+day.month+"_"+day.date+"'><p class='"+day.status+"'>"+day.date+"</p><p class='week_day'>"+days[d]+"</p></li>");
			$.each(day.events, function(i, e) {
				$('#'+day.year+'_'+day.month+'_'+day.date).append("<div class='event_marker event_profile_"+e.profile_id+"'></div>");
				week_event_count++;
			});
		});
		$('#week_'+w+'_heading h2').append('<span class="badge">'+week_event_count+'</span>');
	});
	$('.c-item').each(function(index) {
			var td_id = $(this).attr('id');
			$(this).click(function() {
				
				$.ajax({url: '/profiles/'+profile_id+'/openings/retrieve_events',
					data: 'date='+td_id,
					dataType: 'script'});
				
			});
			
		});

}


var openingUpadateView = function(profile_id, date, calendarEvents) {
	var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	var y = date.getFullYear();
	var m = date.getMonth();
	var d = date.getDate();

	$('#month').text(months[m]+" "+ y);

	var starting = calendarStart(y,m);
	var ending = calendarEnd(y, m);

	var date = starting;

	var calendar = [];
	while(date.getTime() <= ending.getTime()) {
		var week = [];
		for(var i = 0; i < 7; i++) {
			var day = {
				year: date.getFullYear(),
				month: date.getMonth(),
				date: date.getDate(),
				events: []
			}
			if(day.month === m) {
				day.status = "active_day";
			}
			else {
				day.status = "inactive_day";
			}
			$.each(calendarEvents, function(i, object) {
				if(object.year === day.year) {
					$.each(calendarEvents[i].months[day.month].days[day.date -1].events, function(n, x) {
						day.events.push(x);
					});
				}
			});
			week.push(day);
			date.setDate(date.getDate() + 1);
		}

		calendar.push(week);
	}
	openingBuildCalendarView(profile_id, calendar);
	
	
}
var openingInit = function(profile_id, date, calendarEvents) {
	openingUpadateView(profile_id, date, calendarEvents);
}