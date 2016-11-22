//that file need MyChartModule.js

/***********************************************************************************\
    Window.onLoad
\***********************************************************************************/
$(document).on('turbolinks:load', function()
{
  MyApp.Init();
  MyApp.DatePicker.Init("start_date");
  MyApp.DatePicker.Init("end_date");

  //on charge un graphe de base
  MyApp.Chart.Init();

  MyApp.Loading.Start("loading");

  // onChange on the filter "place"
  $("#place_place_id").on('change',function(){
    MyApp.Place.OnChange();
  });

  $("#chartType").on('change',function(){
    MyApp.Chart.ChartTypeOnChange();
  });

  $("#valider").on('click',function(){
    MyApp.Validate();
  });

  $("#download-to-csv").click(function(){
    MyApp.DownloadCsv();
  });


/***********************************************************************************\
                  DESIGN Yann
\***********************************************************************************/
  $('.hasDatepicker').click(function(){
    if($('.lightbox').css('display','none')){
      $('.lightbox').css('display','block');
      $('td').click(function(){
        $('.lightbox').css('display','none');
      });
    }
    else{
      $('.lightbox').css('display','none');
    }
  });
  $('.lightbox').click(function(){
    $('.lightbox').css('display','none');
  });

});
