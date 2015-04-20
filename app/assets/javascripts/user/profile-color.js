var getProfileColors = function(profiles) {
	$.each(profiles, function(index, value) {
		console.log('index: ' + index);
		console.log('title: ' + value.title);
		console.log('color: ' + value.color);
		$('.'+value.title.replace(/\s+/g,'')).css('border', '2px solid '+value.color);
		$('.profile_color.profile_color_'+value.title.replace(/\s+/g,'')).css('border', '1px solid '+value.color);
		$('.a_profile_color.profile_color_'+value.title.replace(/\s+/g,'')).css('background-color', value.color);
		$('.b_profile_color.profile_color_'+value.title.replace(/\s+/g,'')).css('border', '1px solid '+value.color);
		$('span.glyph_color.profile_color_'+value.title.replace(/\s+/g,'')).css('color', value.color);
		$('.event_profile_'+value.id).css('background-color', value.color);
	});
}


// $('document').ready(function() {

	

	

	
	
		// $('.<%= profile.title.gsub(/\s+/,"") %>').css('border', '2px solid <%= profile.color %>');
		// $('.profile_color.profile_color_<%= profile.title.gsub(/\s+/,"")%>').css('border', '1px solid <%= profile.color %>');
		// $('.a_profile_color.profile_color_<%= profile.title.gsub(/\s+/,"")%>').css('background-color', '<%= profile.color %>');
		// $('.b_profile_color.profile_color_<%= profile.title.gsub(/\s+/,"")%>').css('border', '1px solid <%= profile.color %>');
		// $('span.glyph_color.profile_color_<%= profile.title.gsub(/\s+/,"")%>').css('color', '<%= profile.color %>');

		// $('td').click(function() {
		// 	$(this).find('form').submit();
		// });
	
	


// });

