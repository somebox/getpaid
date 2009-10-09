// SRC http://ejohn.org/blog/fast-javascript-maxmin/
Array.max = function( array ){
    return Math.max.apply( Math, array );
};
Array.min = function( array ){
    return Math.min.apply( Math, array );
};

var shadow_offset = 10;

function toggle_elements(selector) {
	elements = $$(selector);
	for (var i=0; i<elements.size(); i++) {
		elements[i].toggle();
	}
}

function hidePopup(){
	Effect.Fade('popup', {duration:0.1});
	$('popup-bg').stopObserving('click', hidePopup);
}

function showPopup(width){
	if (!width) width = 400;
	
	scroll_offset = document.viewport.getScrollOffsets();
	$('popup').show();

	$('popup-container').setStyle('width: ' + width + 'px');
	$('popup-container').setStyle('left: '+ scroll_offset[0] + "px");
	$('popup-container').setStyle('top: ' + scroll_offset[1] + "px");
	
	doResize();
	
	$('popup-bg').setOpacity(0.5);
	$('popup-shadow').setOpacity(0.2);
	$('popup-bg').observe('click', function(){ hidePopup();	})
//	Effect.Appear('popup', {duration: 0.2});	
}

function doResize(){
	if ($('popup').visible()) {
		// resize the background
		content_size = $('content').getDimensions();
		body_size    = $('body').getDimensions();
		width  = [ content_size.width,  body_size.width ].max();
		height = [ content_size.height, body_size.height].max();
		$('popup-bg').setStyle('width: '  + width  + 'px');
		$('popup-bg').setStyle('height: ' + height + 'px');

		popupShadow();
	}
}

function popupShadow() {
	// reposition the popup shadow
	scroll_offset = document.viewport.getScrollOffsets();
	popup_position = $('popup-container').viewportOffset();
	popup_size = $('popup-container').getDimensions();	
	
	$('popup-shadow').setStyle('width: ' + popup_size.width + "px");
	$('popup-shadow').setStyle('height: '+ popup_size.height + "px");	
	$('popup-shadow').setStyle('left: '+ (popup_position[0] + shadow_offset + scroll_offset[0]) + "px");
	$('popup-shadow').setStyle('top: ' + (popup_position[1] + shadow_offset + scroll_offset[1]) + "px");		
}

Event.observe(window, 'resize', function() {
	doResize();
});

function currencyFormatted(amount) {  // SRC http://www.web-source.net/web_development/currency_formatting.htm
	var i = parseFloat(amount);
	if(isNaN(i)) { i = 0.00; }
	var minus = '';
	if(i < 0) { minus = '-'; }
	i = Math.abs(i);
	i = parseInt((i + .005) * 100);
	i = i / 100;
	s = new String(i);
	if(s.indexOf('.') < 0) { s += '.00'; }
	if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
	s = minus + s;
	return '$' + s;
}

function recalculateLineItem() {
	new_total = $('line_item_quantity').value * $('line_item_rate').value;
	$('line_item_total').innerHTML = currencyFormatted(new_total);
	Effect.Highlight($('popup-container'), { startcolor: '#ffff99', endcolor: '#ffffff' });
}

function toggleExtraInvoiceRows() {
	$('discount_row').toggle();
	$('adjustment_row').toggle();
}

function updateBatchCommandSelect(){
	$('service_id').hide();
	$('rate').hide();		
	$('quantity').hide();	
	$('contact_id').hide();
	$('copy_to').hide();
	$($('command').value).show();
}

function updateBatchCommandVisibility(){
	show_batch_commands = 0;
	$$('tr.checkable_row input').each(function(element){
		if (element.checked) { show_batch_commands = 1; }
	})
	if (show_batch_commands) {
		$('batch_commands').show();
	} else {
		$('batch_commands').hide();
	}
}

function observeBatchCommandSelect(){
	$('command').observe('change', function() { updateBatchCommandSelect(); })
	$('body').observe('click', function(e){ 
		$('search_results').hide();
	});
	$('copy_to').observe('focus', function(e){
		if ($$('search_results li')){
			$('search_results').hide();	
		}
	});
}

function chooseQuickFind(number){
	$('copy_to').value = number;
	$('search_results').hide();
}

function observeRowClicks(){
	$$('tr.checkable_row').each(function(element){
		var checkbox = element.firstDescendant().firstChild;
		// console.log(checkbox);
		element.firstDescendant().observe('click', function(){ toggleRowBoxCallback(checkbox,element); });
		element.firstDescendant().observe('click:forfiring', function(){ toggleRowBoxCallback(checkbox,element); });
		checkbox.observe('click', function(){
			checkbox.checked = !checkbox.checked;
		});
	})
	// only show the action bar if stuff is selected
}

function toggleRowBoxCallback(checkbox,element) {
	checkbox.checked = !checkbox.checked;
	if (checkbox.checked) {
		element.addClassName('selected');
	} else {
		element.removeClassName('selected');
	}
}

function toggleAllRowBoxes() {
	$$('tr.checkable_row').each( function(element){ 
		var checkbox = element.firstDescendant().firstChild; 
		checkbox.fire('click:forfiring'); 
	}); 
	return false;
}

function observeBatchCommandVisibility(){
	$$('tr.checkable_row').each(function(element){
		var checkbox = element.firstDescendant().firstChild;
		checkbox.observe('change', function() { 
			updateBatchCommandVisibility();
		});
	});
	
}

function observeNoticeArea(){
	$('notice').observe('click', function(){$('notice').hide()})
}

function initInvoiceEditUI(){
	updateBatchCommandSelect(); 
	observeBatchCommandSelect(); 
	observeRowClicks();
	observeNoticeArea();
}

function initInvoiceListUI(){
	observeRowClicks();
	observeNoticeArea();
	observeBatchCommandVisibility();
	updateBatchCommandVisibility();
}