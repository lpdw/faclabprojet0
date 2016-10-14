
$(function(){

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
    console.log("Place : "+name_of_place+" => "+dayFilter+"/"+monthFilter+"/"+yearFilter);

    var name_of_place = $("#place_place_id").val();
    var datas = {
                dayFilter: dayFilter,
                monthFilter: monthFilter,
                yearFilter: yearFilter
              };

    var request = $.ajax({
                  url: '/visits/index',
                  method: 'POST',
                  data: datas,
                  dataType: 'json',
                });

    request.done(function(data){
      // chargement de la chartJS
      // var data = JSON.parse(data);
      console.log(data);
    });
    request.fail(function(err){
      console.log(err);
    });

  }//end of loadMyChart()

});
