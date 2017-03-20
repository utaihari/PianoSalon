# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


	#後のイベントで、不要なoption要素を削除するため、オリジナルをとっておく
	#地方側のselect要素が変更になるとイベントが発生
$( ->
	$children = $('#room-select')
	#都道府県の要素を変数に入れます。
	original = $children.html()

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

)