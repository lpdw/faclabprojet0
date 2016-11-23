//require MyChartModule.js

$(document).on('turbolinks:load', function()
{
  MyApp.Init();
  MyApp.DatePicker.Init("start_date");
  MyApp.DatePicker.Init("end_date");

  //load myChart
  MyApp.Chart.Init();
  //show loading => stop when data loaded
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
//Use a tiny library to convert convas -> blob and save as a file like png
 $("#pdfview").on("click",function() {
   $("#myChart").get(0).toBlob(function(blob) {
     setTimeout(1000);
     saveAs(blob, MyApp.Init()+"_Export.png");
   });
 });





});
