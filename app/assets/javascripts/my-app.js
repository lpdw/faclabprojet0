
$(function(){

  /****************************************************************\
            OnChangesur chaque filtre
  \****************************************************************/
  // onChange sur le filtre "year"
  $("#start_date_year").on('change',function(){
    var yearFilter = $(this).val();
    var monthFilter = $("#start_date_month").val();
    var dayFilter = $("#start_date_day").val();
    loadMyChart(dayFilter,monthFilter,yearFilter);
  });

  // onChange sur le filtre "month"
  $("#start_date_month").on('change',function(){
    var monthFilter = $(this).val();
    var yearFilter = $("#start_date_year").val();
    var dayFilter = $("#start_date_day").val();
    loadMyChart(dayFilter,monthFilter,yearFilter);
  });

  // onChange sur le filtre "day"
  $("#start_date_day").on('change',function(){
    var dayFilter = $(this).val();
    var yearFilter = $("#start_date_year").val();
    var monthFilter = $("#start_date_month").val();
    loadMyChart(dayFilter,monthFilter,yearFilter);
  });



  function loadMyChart(dayFilter,monthFilter,yearFilter)
  {
    var opts = {
        lines: 13 // The number of lines to draw
      , length: 28 // The length of each line
      , width: 14 // The line thickness
      , radius: 42 // The radius of the inner circle
      , scale: 1 // Scales overall size of the spinner
      , corners: 1 // Corner roundness (0..1)
      , color: '#000' // #rgb or #rrggbb or array of colors
      , opacity: 0.25 // Opacity of the lines
      , rotate: 0 // The rotation offset
      , direction: 1 // 1: clockwise, -1: counterclockwise
      , speed: 1 // Rounds per second
      , trail: 60 // Afterglow percentage
      , fps: 20 // Frames per second when using setTimeout() as a fallback for CSS
      , zIndex: 2e9 // The z-index (defaults to 2000000000)
      , className: 'spinner' // The CSS class to assign to the spinner
      , top: '50%' // Top position relative to parent
      , left: '50%' // Left position relative to parent
      , shadow: false // Whether to render a shadow
      , hwaccel: false // Whether to use hardware acceleration
      , position: 'absolute' // Element positioning
    }

    $("#my-spin").show();
    var target = document.getElementById('my-spin');
    var spinner = new Spinner(opts).spin(target);

    console.log("Place : "+name_of_place+" => "+dayFilter+"/"+monthFilter+"/"+yearFilter);

    var name_of_place = $("#place_place_id").val();
    var datas = {
                dayFilter: dayFilter,
                monthFilter: monthFilter,
                yearFilter: yearFilter
              };

    var request = $.ajax({
                  url: "/visits/index",
                  method: 'POST',
                  data: datas,
                  dataType: "json",
                });

    request.then(function(data){
      // chargement de la chartJS
      $("#my-spin").hide();
      console.log(data);
    });
    request.fail(function(err){
      $("#my-spin").hide();
      console.log(err);
    });

  }//end of loadMyChart()

});
