
$(function(){
  // gestion de l'affichage du chart js ici

  // recuperation des valeurs filtres
  var yearFilter = $("#start_date_year").val();
  var monthFilter = $("#start_date_month").val();
  var dayFilter = $("#start_date_day").val();

  // onChange sur le filtre "year"
  $("#start_date_year").on('change',function(){
    var yearFilter = $(this).val();
    var monthFilter = $("#start_date_month").val();
    var dayFilter = $("#start_date_day").val();
    console.log(dayFilter+"/"+monthFilter+"/"+yearFilter);
  });

  // onChange sur le filtre "month"
  $("#start_date_month").on('change',function(){
    var monthFilter = $(this).val();
    var yearFilter = $("#start_date_year").val();
    var dayFilter = $("#start_date_day").val();
    console.log(dayFilter+"/"+monthFilter+"/"+yearFilter);
  });

  // onChange sur le filtre "day"
  $("#start_date_day").on('change',function(){
    var dayFilter = $(this).val();
    var yearFilter = $("#start_date_year").val();
    var monthFilter = $("#start_date_month").val();
    console.log(dayFilter+"/"+monthFilter+"/"+yearFilter);
  });
})
