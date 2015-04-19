$(document).ready(function() {

	$('#control_panel_open_tab').click(function() {
		$('#control_panel_tab_close').toggle();
		$('#control_panel_container').removeClass('slideLeft').addClass('slideRight');
			$('#control_panel_container').one('webkitAnimationEnd oanimationend msAnimationEnd animationend', function(e) {
				$('#control_panel_container').toggle();
				$('body').removeClass('body_no_scroll');
				// $('#control_panel_tab_close').toggle();
			});
	});

	$('#control_panel_close_tab').click(function() {
		$('#control_panel_tab_close').toggle();
		$('#control_panel_container').toggle();
		$('body').addClass('body_no_scroll');
		$('#control_panel_container').removeClass('slideRight').addClass('slideLeft');
	});
});