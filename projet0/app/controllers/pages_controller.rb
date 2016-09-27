class PagesController < ApplicationController


  def home
    day = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "SAmedi", "Dimanche"]
    @data = {
      labels: day,
      datasets: [
        {
            label: "Capteur 1 : salle X",
            fill: false,
            backgroundColor: "rgba(220,220,220,0.2)",
            borderColor: "rgba(220,220,220,1)",
            data: [3, 5, 2, 7, 6, 2, 4]
        }
      ]
    }
    @options = {
      responsive: true,
      scales: {
          yAxes: [{
              ticks: {
                  beginAtZero:true
              }
          }]
      }
    }
  end

end
