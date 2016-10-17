
$(function(){

  //on charge une charte de base avec
  loadMyChartData();

  /****************************************************************\
            OnChangesur chaque filtre
  \****************************************************************/
  // onChange sur le filtre "year"
  $("#start_date_year").on('change',function(){
    var filters = [];
    filters['yy'] = $(this).val();
    filters['mm'] = $("#start_date_month").val();
    filters['dd'] = $("#start_date_day").val();

    loadMyChartData(filters);
  });

  // onChange sur le filtre "month"
  $("#start_date_month").on('change',function(){
    var filters = [];
    filters['mm'] = $(this).val();
    filters['dd'] = $("#start_date_day").val();
    filters['yy'] = $("#start_date_year").val();

    loadMyChartData(filters);
  });

  // onChange sur le filtre "day"
  $("#start_date_day").on('change',function(){
    var filters = [];
    filters['dd'] = $(this).val();
    filters['yy'] = $("#start_date_year").val();
    filters['mm'] = $("#start_date_month").val();

    loadMyChartData(filters);
  });

  // onChange sur type de filtre que l'on veut
  $("#chartType").on('change',function(){
    $("#chartType").trigger('typeChanged');
  });

  function ajaxRequest(dd,mm,yy)
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
  }

  /****************************************************************\
          Affichage de la Chart
  \****************************************************************/
  function loadMyChartData(filters)
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

      console.log("Chargement de base loadMyChartData()");
      request = ajaxRequest(dd,mm,yy);
      date_stat = dd+"/"+mm+"/"+yy;

      request.then(function(data){
        DrawMyChart(data.labels,data.datas,date_stat);
      });
      request.fail(function(err){ $("#my-spin").hide(); console.log(err); });
    }
    else
    {
      request = ajaxRequest(filters['dd'],filters['mm'],filters['yy']);
      date_stat = filters['dd']+"/"+filters['mm']+"/"+filters['yy'];

      request.then(function(data){
         DrawMyChart(data.labels,data.datas,date_stat);
      });
      request.fail(function(err){ $("#my-spin").hide(); console.log(err); });
    }
  }

  var chartInstance = null;
  function DrawMyChart(labels,datas_from_db,date_stat)
  {
    console.log(datas_from_db);
    var ctx = document.getElementById("myChart").getContext("2d");
    ctx.canvas.width = 400;
    ctx.canvas.height = 300;

    var datas = {
      labels: labels,
      datasets: [
        {
            label: " nombres de personne ",
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
      legend: true,
      scales: { yAxes: [{ ticks: { beginAtZero:true } }] }
    }

    var type = $("#chartType").val();

    datas = loadDatasForChart(type,labels,datas_from_db);
    chartInstance = new Chart(ctx, {
        type: type,
        data: datas,
        options: options
    });

    $("#chartType").bind('typeChanged',function()
    {
      var type = $(this).val();
      chartInstance.destroy();
      datas = loadDatasForChart(type,labels,datas_from_db);

      chartInstance = new Chart(ctx, {
          type: $(this).val(),
          data: datas,
          options: options
      });
    });
  }


  function loadDatasForChart(chartType,labels,datas_from_db)
  {
    var datas = null;
    if (chartType === "line")
    {
      datas = {
        labels: labels,
        datasets: [
          {
              label: " nombres de personne ",
              backgroundColor: "#83D6DE",
              borderColor: "#1DABB8",
              data: datas_from_db
          }
        ]
      }
    }
    else if (chartType === "bar")
    {
      datas = {
      labels: labels,
      datasets: [
          {
              label: "My First dataset",
              backgroundColor: [
                  'rgba(255, 99, 132, 0.2)',
                  'rgba(54, 162, 235, 0.2)',
                  'rgba(255, 206, 86, 0.2)',
                  'rgba(75, 192, 192, 0.2)',
                  'rgba(153, 102, 255, 0.2)',
                  'rgba(255, 159, 64, 0.2)'
              ],
              borderColor: [
                  'rgba(255,99,132,1)',
                  'rgba(54, 162, 235, 1)',
                  'rgba(255, 206, 86, 1)',
                  'rgba(75, 192, 192, 1)',
                  'rgba(153, 102, 255, 1)',
                  'rgba(255, 159, 64, 1)'
              ],
              borderWidth: 1,
              data: datas_from_db,
          }
        ]
      };
    }
    else if (chartType === "radar")
    {
      datas = {
        labels: labels,
        datasets: [{
              label: "My First dataset",
              backgroundColor: "rgba(179,181,198,0.2)",
              borderColor: "rgba(179,181,198,1)",
              pointBackgroundColor: "rgba(179,181,198,1)",
              pointBorderColor: "#fff",
              pointHoverBackgroundColor: "#fff",
              pointHoverBorderColor: "rgba(179,181,198,1)",
              data: datas_from_db
          }]
      };
    }
    else if (chartType === "polarArea")
    {
      datas = {
        labels: labels,
        datasets: [{
            data: datas_from_db,
            backgroundColor: [
                "#FF6384",
                "#4BC0C0",
                "#FFCE56",
                "#E7E9ED",
                "#36A2EB"
            ],
            // label: 'My dataset' // for legend
        }]
      };
    }
    else if (chartType === "pie")
    {
      datas = {
        labels: labels,
        datasets: [
            {
                data: datas_from_db,
                backgroundColor: [
                    "#FF6384",
                    "#36A2EB",
                    "#FFCE56",
                    "#df57b3",
                ],
                hoverBackgroundColor: [
                    "#FF6384",
                    "#36A2EB",
                    "#FFCE56",
                    "#df57b3",
                ]
            }]
      };
    }

    return datas;
  }

});
