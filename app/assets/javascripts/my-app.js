
$(function(){

  //on charge une charte de base avec
  loadMyChart();

  /****************************************************************\
            OnChangesur chaque filtre
  \****************************************************************/
  // onChange sur le filtre "year"
  $("#start_date_year").on('change',function(){
    var filters = [];
    filters['yy'] = $(this).val();
    filters['mm'] = $("#start_date_month").val();
    filters['dd'] = $("#start_date_day").val();
    loadMyChart(filters);
  });

  // onChange sur le filtre "month"
  $("#start_date_month").on('change',function(){
    var filters = [];
    filters['mm'] = $(this).val();
    filters['dd'] = $("#start_date_day").val();
    filters['yy'] = $("#start_date_year").val();
    loadMyChart(filters);
  });

  // onChange sur le filtre "day"
  $("#start_date_day").on('change',function(){
    var filters = [];
    filters['dd'] = $(this).val();
    filters['yy'] = $("#start_date_year").val();
    filters['mm'] = $("#start_date_month").val();
    loadMyChart(filters);
  });

  /****************************************************************\
          Fonction qui va récuperer les donées
  \****************************************************************/
  function getDatasForMyChart(dd,mm,yy)
  {
    var place_name = $("#place_place_id").val();
    var datas = {
                dayFilter: dd,
                monthFilter: mm,
                yearFilter: yy,
                place_name: place_name
              };

    return $.ajax({
                  url: "/visits/index",
                  method: 'POST',
                  data: datas,
                  dataType: "json",
                });

  }//end of getDatasForMyChart()

  /****************************************************************\
          Chargement de la charte
  \****************************************************************/
  function loadMyChart(filters)
  {
    //label "Stat du : X"
    var date_stat = "";

    //recupere une promise qui va recuperer les infos depuis la bdd
    var request = "";

    // Chargement de base de la charte
    if(typeof filters === "undefined")
    {
      var date = new Date();
      var dd = date.getDate();
      var mm = date.getMonth()+1;
      var yy = date.getFullYear();

      console.log("Chargement de base loadMyChart()");
      request = getDatasForMyChart(dd,mm,yy);
      date_stat = dd+"/"+mm+"/"+yy;

      request.then(function(data){
        showChart(data.labels,data.datas,date_stat);
      });
      request.fail(function(err){ $("#my-spin").hide(); console.log(err); });
    }
    else
    {
      request = getDatasForMyChart(filters['dd'],filters['mm'],filters['yy']);
      date_stat = filters['dd']+"/"+filters['mm']+"/"+filters['yy'];

      request.then(function(data){
         showChart(data.labels,data.datas,date_stat);
       });
      request.fail(function(err){ $("#my-spin").hide(); console.log(err);
      });
    }
  }//end Of loadMyChart()


  function showChart(labels,datas_from_db,date_stat)
  {
    var ctx = document.getElementById("myChart").getContext("2d");

    var datas = {
      labels: labels,
      datasets: [
        {
            label: " nb personne ",
            backgroundColor: "#83D6DE",
            borderColor: "#1DABB8",
            data: datas_from_db
        }
      ]
    }
    var options = {
      title: {
            display: true,
            text: 'Statistiques du ' + date_stat,
        },
      legend: false,
      scales: { yAxes: [{ ticks: { beginAtZero:true } }] }
    }

    var chartInstance = new Chart(ctx, {
        type: 'line',
        data: datas,
        options: options
    });
  }

});
