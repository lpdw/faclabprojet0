class PagesController < ApplicationController

  def home
    labels_day = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"]
    labels_month = ["January", "February", "March", "April", "May", "June", "July"]

    #
    # GENERATE A LINE CHART #
    #
    @data_line_chart = {
      labels: labels_month,
      datasets: [
        {
            label: "My first dataset",
            fill: false,
            backgroundColor: "#F8BBD0",
            borderColor: "#E91E63",
            data: [65, 59, 80, 81, 56, 55, 40]
        },
        {
            label: "My first dataset",
            fill: false,
            backgroundColor: "#8EFFC1",
            borderColor: "#3EDC81",
            data: [5, 9, 2 , 1, 6, 7, 4]
        }
      ]
    }
    @options_line_chart = {
      responsive: true,
      maintainAspectRatio: false,
      legend: {
            display: false
      },
      scales: {
            yAxes: [{
                ticks: {
                    beginAtZero:true
                }
            }]
        }
    }

    #
    # GENERATE A BAR CHART
    #
    @data_bar_chart = {
      labels: labels_month,
      datasets: [
        {
            # label: "My first dataset",
            fill: false,
            backgroundColor: [
                'rgba(233, 30, 99, .2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)',
                'rgba(255, 159, 64, 0.2)'
            ],
            borderColor: [
                'rgba(233, 30, 99, 1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
            ],
            borderWidth: 1,
            data: [65, 59, 80, 81, 56, 55, 40]
        }
      ]
    }
    @options_bar_chart = {
      responsive: true,
      maintainAspectRatio: false,
      legend: {
            display: false
      },
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
