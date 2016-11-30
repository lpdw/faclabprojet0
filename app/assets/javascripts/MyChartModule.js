var MyApp =
{
  _dateToday : "",
  _request : null,
  _filtersInit : [],
  _filtersOnChange : [],
  Loading :
  {
    _opts : {
        lines: 11 // The number of lines to draw
      , length: 28 // The length of each line
      , width: 7 // The line thickness
      , radius: 30 // The radius of the inner circle
      , scale: 1 // Scales overall size of the spinner
      , corners: 1 // Corner roundness (0..1)
      , color: '#888' // #rgb or #rrggbb or array of colors
      , opacity: 0.25 // Opacity of the lines
      , rotate: 0 // The rotation offset
      , direction: 1 // 1: clockwise, -1: counterclockwise
      , speed: 1 // Rounds per second
      , trail: 60 // Afterglow percentage
      , fps: 20 // Frames per second when using setTimeout() as a fallback for CSS
      , zIndex: 2e9 // The z-index (defaults to 2000000000)
      , className: 'spinner' // The CSS class to assign to the spinner
      , top: '45%' // Top position relative to parent
      , left: '50%' // Left position relative to parent
      , shadow: false // Whether to render a shadow
      , hwaccel: false // Whether to use hardware acceleration
      // , position: 'absolute' // Element positioning
    },
    _target : null,
    _spinner : null,
    Start : function(item){
      //utilise MyApp au lieu de this car cette methode est appelle a des postions différentes
      MyApp.Loading._target = document.getElementById(item);
      MyApp.Loading._spinner = new Spinner(MyApp.Loading._opts).spin(MyApp.Loading._target);
      $(MyApp.Loading._target).data('spinner', MyApp.Loading._spinner);
    },
    Stop : function(){
      $('#loading').data('spinner').stop();
      $("#myChart").show();
    }
  },
  DatePicker :
  {
    _startDate : null,
    _endDate : null,
    Init : function(item){
      if (item == "start_date") {
        MyApp.DatePicker._startDate = $("#start_date").datepicker({
          dateFormat: 'yy-mm-dd',
          minDate: new Date(2014,12,1), // it will set minDate from 1 january 2015
          changeMonth: true,
          maxDate: '+0m +0w',
          numberOfMonths: 1
        });
      }
      else {
        MyApp.DatePicker._endDate = $("#end_date").datepicker({
          dateFormat: 'yy-mm-dd',
          defaultDate: "0w",
          changeMonth: true,
          maxDate: '+0m +0w',
          numberOfMonths: 1,
          minDate: MyApp._startDate
        });
      }
    },
  },
  Chart :
  {
    _datas : [],
    _labels : [],
    _chartInstance : null,
    _chartType : "",
    Init : function (){
      $("#myChart").hide();
      this.LoadMyChart(true);
    },
    LoadMyChart : function(init) // reçoit un booleen qui indique si c'est init ou reload
    {
      MyApp._filtersInit = [];
      MyApp._filtersOnChange = [];
      this._chartType = $("#chartType").val();

      if(init === true) //si c'est un chargement de base (1ère ouverture navigateur)
      {

        MyApp._filtersInit['place_id'] = $("#place_place_id").val(); //dans les 2 cas j'ai besoin de la place
        MyApp._filtersInit['start_date']   = MyApp._dateToday;
        MyApp._filtersInit['end_date']     = MyApp._dateToday;

        MyApp._request = MyApp.AjaxRequest(MyApp._filtersInit);
        MyApp._request.then(function(data){
          MyApp.Loading.Stop();
          MyApp.Chart._datas = data.datas;
          MyApp.Chart._labels = data.labels;
          MyApp.Chart.DrawMyChart();
        });
        MyApp._request.fail(function(err){console.log(err); });
      }
      else
      {
        MyApp._filtersOnChange['place_id'] = $("#place_place_id").val(); //dans les 2 cas j'ai besoin de la place
        MyApp._filtersOnChange['start_date']   = $("#start_date").val();
        MyApp._filtersOnChange['end_date']     = $("#end_date").val();

        MyApp._request = MyApp.AjaxRequest(MyApp._filtersOnChange);
        MyApp._request.then(function(data){
          MyApp.Loading.Stop();
          MyApp.Chart._datas = data.datas;
          MyApp.Chart._labels = data.labels;
          MyApp.Chart.DrawMyChart(this._labels,this._datas);
        });
        MyApp._request.fail(function(err){console.log(err); });
      }
    },
    DrawMyChart : function()
    {
      MyApp.Loading.Stop();

      var infos = null;
      var ctx = document.getElementById("myChart").getContext("2d");
      ctx.canvas.width = 500;
      ctx.canvas.height = 350;

      var type = $("#chartType").val();

      infos = this.GetTypeChart(this._chartType,this._labels,this._datas);
      this._chartInstance = new Chart(ctx, {
          type: type,
          data: infos['datas'],
          options: infos['options']
      });
    },
    ChartTypeOnChange : function()
    {
        this._chartTypetype = $(this._chartType).val();
        this._chartInstance.destroy();
        MyApp.Loading.Stop();

        var infos = this.GetTypeChart(this._chartTypetype,this._labels,this._datas);
        var ctx = document.getElementById("myChart").getContext("2d");
        ctx.canvas.width = 400;
        ctx.canvas.height = 300;

        this._chartInstance = new Chart(ctx, {
            type: $("#chartType").val(),
            data: infos['datas'],
            options: infos['options']
        });
    },
    GetTypeChart : function()
    {
      //on va utiliser des couleurs aletaoires
      var tabColors = [];
      var tabBorderColor = [];
      for (var i = 0; i < this._datas.length; i++) {
        var color = 'rgb(' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ')';
        tabColors[i] = color;
      }

      var infos  = [];
      var datas = null;
      var options = null;

      this._chartType = $("#chartType").val();
      if (this._chartType === "line")
      {
        datas = {
          labels: this._labels,
          datasets: [
            {
                label: " Nombre de personnes ",
                backgroundColor: "#83D6DE",
                borderColor: "#1DABB8",
                data: this._datas
            }
          ]
        }
        options = {
            animation : {
              easing:'easeOutBounce',
              duration:1500,
              animateScale:true
            },
            legend: {display:true},
            scales: { yAxes: [{ ticks: { beginAtZero:true } }] }
        }
      }
      else if (this._chartType === "bar")
      {
        var colors = [];
        for (var i = 0; i < tabColors.length; i++)
        {
          tabBorderColor[i] = tabColors[i].replace("rgb","");
          tabBorderColor[i] = tabBorderColor[i].replace("(","");
          tabBorderColor[i] = tabBorderColor[i].replace(")","");
          colors[i] = 'rgba('+tabBorderColor[i]+',0.2)';
          tabBorderColor[i] = 'rgba('+tabBorderColor[i]+',1)';
        }

        datas = {
          labels: this._labels,
          datasets: [
              {
                  label: "Nombres de personnes",
                  backgroundColor: colors,
                  borderColor: tabBorderColor,
                  borderWidth: 1,
                  data: this._datas,
              }
            ]
        };
        options = {
            legend: {display:true},
            scales: { yAxes: [{ ticks: { beginAtZero:true } }] }
        }
      }

      infos['datas'] = datas;
      infos['options'] = options;
      return infos;
    }
  },
  Place : {
    OnChange : function(){
      MyApp.Validate();
    }
  },
  Init : function()
  {
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth()+1; //January is 0!
    var yyyy = today.getFullYear();

    if(dd<10)
      dd='0'+dd;
    if(mm<10)
        mm='0'+mm;
    today = yyyy+"-"+mm+"-"+dd;
    this._dateToday = today;
  },
  AjaxRequest : function(filtersParams)
  {
    var datasToSend = {
        start_date : filtersParams['start_date'],
        end_date : filtersParams['end_date'],
        place_id : filtersParams['place_id'],
    };
    return $.ajax({
                  url : "/visits/index",
                  method : 'POST',
                  data : datasToSend,
                  dataType: "json",
                });
  },
  Validate : function()
  {
    this.Loading.Start("loading");

    this._filtersOnChange['place_id'] = $("#place_place_id").val();
    this._filtersOnChange['start_date']   = this.DatePicker._startDate.val();
    this._filtersOnChange['end_date']     = this.DatePicker._endDate.val();

    console.log("from : "+this._filtersOnChange['start_date']);
    console.log("to : "+this._filtersOnChange['end_date']);
    this.Chart._chartInstance.destroy();
    this.Chart.LoadMyChart(this._filtersOnChange);
  },
  DownloadCsv : function()
  {
    if (this.Chart._datas.length <= 0 || this.Chart._labels.length <= 0)
      alert("pas de données disponibles à telecharger");
    else
    {
      var dataToExport = [ JSON.parse(JSON.stringify(this.Chart._labels)), JSON.parse(JSON.stringify(this.Chart._datas)) ];
      var allDatasCsv =  [];

      var firstRow = this.Chart._labels[0];
      if (firstRow.split(" ")[1] == "h") {
        for (var i = 0; i < this.Chart._labels.length; i++) {
          var row = this.Chart._labels[i].split(" ");
          allDatasCsv.push({
            "Heure": row[0]+"h",
        		"Visites": this.Chart._datas[i]
          })
        }
      }
      else {
        for (var i = 0; i < this.Chart._labels.length; i++) {
          allDatasCsv.push({
            "Jour": this.Chart._labels[i],
        		"Visites": this.Chart._datas[i]
          })
        }
      }

      var csv = Papa.unparse( { data:allDatasCsv }, { delimiter: ";" } );

      var blob = new Blob([csv]);
      var a = window.document.createElement("a");
      a.href = window.URL.createObjectURL(blob,{type:"text/plain"});
      a.download = "faclab.csv";
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      console.log(csv);
    }
  }
}
