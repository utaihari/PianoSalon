# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


	#後のイベントで、不要なoption要素を削除するため、オリジナルをとっておく
	#地方側のselect要素が変更になるとイベントが発生
$( ->
	$children = $('#room-select')
	#都道府県の要素を変数に入れます。
	original = $children.html()
	@room_id = $('#calendar-data').data('room_id')

	$('#area-select').change ->
		#選択された地方のvalueを取得し変数に入れる
		val1 = $(this).val()
		#削除された要素をもとに戻すため.html(original)を入れておく
		$children.html(original).find('option').each ->
			val2 = $(this).data('val')
			if +val1 isnt +val2
		    	$(this).not(':first-child').remove()
		    return
		# #地方側のselect要素が未選択の場合、都道府県をdisabledにする
		if $(this).val() == ''
			$children.attr 'disabled', 'disabled'
		else
		    $children.removeAttr 'disabled'
		return

	$children.change ->
		$.get("/schedules/calendar/#{$(this).val()}")
		return
	$('#schedule_salon_id').change ->
		$('#schedule_title').val($('#schedule_salon_id').text())
		return

	$('#schedule_start_time_1i').change ->
		console.log("changed")
		check_overlap()
		return
	$('#schedule_start_time_2i').change ->
		check_overlap()
		return
	$('#schedule_start_time_3i').change ->
		check_overlap()
		return
	$('#schedule_start_time_4i').change ->
		check_overlap()
		return
	$('#schedule_start_time_5i').change ->
		check_overlap()
		return

	$('#schedule_end_time_1i').change ->
		check_overlap()
		return
	$('#schedule_end_time_2i').change ->
		check_overlap()
		return
	$('#schedule_end_time_3i').change ->
		check_overlap()
		return
	$('#schedule_end_time_4i').change ->
		check_overlap()
		return
	$('#schedule_end_time_5i').change ->
		check_overlap()
		return
)

check_overlap = ->
	@room_id = $('#calendar-data').data('room_id')
	start_time = get_start_time()
	end_time = get_end_time()
	$.getJSON("/schedules/check_overlap/#{@room_id}/#{start_time}/#{end_time}", (data) ->
		console.log(data)
		if data
			$('#schedule-errors').html("<font color=\"red\">この時間の予約はできません</font>")
			$('#schedule-submit').prop("disabled", true);
		else
			$('#schedule-errors').html("")
			$('#schedule-submit').prop("disabled", false);
		)
	return
get_start_time = ->
	year = $('#schedule_start_time_1i').val()
	month = $('#schedule_start_time_2i').val()
	day = $('#schedule_start_time_3i').val()
	hour = $('#schedule_start_time_4i').val()
	min = $('#schedule_start_time_5i').val()
	return "#{year}, #{month}, #{day}, #{hour}, #{min}"
get_end_time = ->
	year = $('#schedule_end_time_1i').val()
	month = $('#schedule_end_time_2i').val()
	day = $('#schedule_end_time_3i').val()
	hour = $('#schedule_end_time_4i').val()
	min = $('#schedule_end_time_5i').val()
	return "#{year}, #{month}, #{day}, #{hour}, #{min}"
