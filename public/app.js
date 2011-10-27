(function($){
    $(document).ready(function() {
        $("input:text").focus(function() { $(this).select(); } );
    }).mouseup(function(e){e.preventDefault();});
    $("table").dataTable();
    var updateLayout = function() {
        if (window.innerWidth != currentWidth) {
            currentWidth = window.innerWidth; var orient = (currentWidth == 320) ? "profile" : "landscape"; document.body.setAttribute("orient", orient);
            window.scrollTo(0, 1);
            }
            }; iPhone.DomLoad(updateLayout); setInterval(updateLayout, 500); 
    
})(jQuery);