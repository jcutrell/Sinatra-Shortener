(function($){
    $(document).ready(function() {
        $("input:text").focus(function() { $(this).select(); } );
    }).mouseup(function(e){e.preventDefault();});
    $("table").dataTable();
})(jQuery);