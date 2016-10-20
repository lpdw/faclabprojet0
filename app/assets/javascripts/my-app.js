
$(document).on('turbolinks:load', function() {


  var dateFormat = 'yy-mm-dd',
      start_date = $( "#start_date" )
        .datepicker({
          dateFormat: 'yy-mm-dd',
          defaultDate: "+1w",
          changeMonth: true,
          numberOfMonths: 1
        })
        .on( "change", function() {
          end_date.datepicker( "option", "minDate", getDate( this ) );
        }),
      end_date = $( "#end_date" ).datepicker({
        dateFormat: 'yy-mm-dd',
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1
      })
      .on( "change", function() {
        start_date.datepicker( "option", "maxDate", getDate( this ) );
      });

  function getDate( element ) {
    var date;
    try {
      date = $.datepicker.parseDate( dateFormat, element.value );

    } catch( error ) {
      date = null;
    }
    return date;
  }

  //on charge une charte de base avec
  loadMyChartData();

  // onChange on the filter "place"
  $("#place_place_id").on('change',function(){
    var filters = [];
    filters['id_place'] = $(this).val();
    filters['start_date']   = start_date.val();
    filters['end_date']     = end_date.val();
    loadMyChartData(filters);
  });

  // onChange sur type de filtre que l'on veut
  $("#chartType").on('change',function(){
    $("#chartType").trigger('typeChanged');
  });

  $("#valider").on('click',function(){
    var filters = [];
    filters['id_place'] = $("#place_place_id").val();
    filters['start_date']   = start_date.val();
    filters['end_date']     = end_date.val();
    loadMyChartData(filters);
  });

  function ajaxRequest(filters)
  {
    if (typeof filters === "undefined")
    {
      var filters = [];
      filters['start_date'] = getDateToday();
      filters['end_date'] = getDateToday();
    }
    else {
      if(filters['start_date'] === "" && filters['end_date'] === ""){
        filters['start_date'] = getDateToday();
        filters['end_date'] = getDateToday();
      }
    }


    filters['id_place'] = $("#place_place_id").val();
    var datas = {
        start_date: filters['start_date'],
        end_date: filters['end_date'],
        id_place: filters['id_place']
    };

    return $.ajax({
                  url: "/visits/index",
                  method: 'POST',
                  data: datas,
                  dataType: "json",
                });
  }

  function loadMyChartData(filters)
  {
    //label "Stat du : X"
    var date_stat = null;

    var request = null;

    // Chargement de base de la charte
    if(typeof filters === "undefined")
    {
      request = ajaxRequest(filters);

      request.then(function(data){ DrawMyChart(data.labels,data.datas); });
      request.fail(function(err){ $("#my-spin").hide(); console.log(err); });
    }
    else
    {
      request = ajaxRequest(filters);

      request.then(function(data){ DrawMyChart(data.labels,data.datas); });
      request.fail(function(err){ $("#my-spin").hide(); console.log(err); });
    }
  }

  var chartInstance = null;
  function DrawMyChart(labels,datas_from_db)
  {
    console.log(datas_from_db);
    var infos = null;
    var ctx = document.getElementById("myChart").getContext("2d");
    ctx.canvas.width = 400;
    ctx.canvas.height = 300;

    var type = $("#chartType").val();

    infos = loadDatasForChart(type,labels,datas_from_db);
    chartInstance = new Chart(ctx, {
        type: type,
        data: infos['datas'],
        options: infos['options']
    });

    $("#chartType").bind('typeChanged',function(){
      var type = $(this).val();
      chartInstance.destroy();
      infos = loadDatasForChart(type,labels,datas_from_db);

      chartInstance = new Chart(ctx, {
          type: $(this).val(),
          data: infos['datas'],
          options: infos['options']
      });
    });

  }


  function loadDatasForChart(chartType,labels,datas_from_db)
  {
    var datas = null;
    var options = null;
    var infos  = [];
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
      options = {
        title: {
                display: true,
                text: 'Statistiques du ',
            },
          animation : {
            easing:'easeOutBounce',
            duration:1500,
            animateScale:true
          },
          legend: {display:true},
          scales: { yAxes: [{ ticks: { beginAtZero:true } }] }
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
      options = {
        title: {
                display: true,
                text: 'Statistiques du ',
            },
          legend: {display:true},
          scales: { yAxes: [{ ticks: { beginAtZero:true } }] }
      }
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
      options = {
        animation : {
          easing:'easeOutBounce',
          duration:1500,
          animateScale:true
        }
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
      options = {
        animation : {
          easing:'easeOutBounce',
          duration:1500,
          animateScale:true
        }
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
      options = {
        animation : {
          easing:'easeOutBounce',
          duration:1500,
          animateScale:true
        }
      };
    }


    infos['datas'] = datas;
    infos['options'] = options;

    return infos;
  }

  function getDateToday()
  {
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth()+1; //January is 0!
    var yyyy = today.getFullYear();

    if(dd<10)
      dd='0'+dd;
    if(mm<10)
        mm='0'+mm;
    today = yyyy+"-"+dd+"-"+mm;
    return today;
  }
});
