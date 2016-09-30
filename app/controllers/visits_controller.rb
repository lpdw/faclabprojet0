class VisitsController < ApplicationController
  before_action :set_visit, :only => [:show,:edit,:destroy,:update]

  # GET /visits
  # GET /visits.json
  def index
    @visits = Visit.all

    @places = Place.all

    labels_hours = Array.new
    hour = 9
    while hour < 20
      hour += 1
      labels_hours.push(hour.to_s + "h")
    end

    labels_days = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"]
    labels_months = ["Jan", "Fevr", "Mars", "Avril", "Mai", "Juin", "Juillet","Aout","Sept","Oct","Nov","Dec"]

    # graph de base
    # => on affiche les stats d'hier
    # => sinon on affiche celui de vendredi
    #
    today = Date.today
    week = today.saturday? || today.sunday?
    if week
      #recuperation du stat de vendredi
      day_x = "recuperation des stats de vendredi"
      data = [5,9,7,1,2,3,4,2,3,5,8]
    else
      #recuperation du stat d'hier
      day_x = (Date.yesterday).strftime("%d/%m/%Y")
      data = [1,6,7,1,2,3,4,2,3,5,3]
    end


    @data = {
      labels: labels_hours,
      datasets: [
        {
            label: " nb personne ",
            backgroundColor: "#83D6DE",
            borderColor: "#1DABB8",
            data: data
        }
        # {
        #     label: "Jour Y ",
        #     backgroundColor: "rgba(151,187,205,0.2)",
        #     borderColor: "rgba(151,187,205,1)",
        #     data: [28, 48, 40, 19, 86, 27, 90,12,58,65,47,30]
        # }
      ]
    }
    @options = {
      xLabels: false,
      title: {
            display: true,
            text: 'STATISTIQUES DU ' + day_x,
        },
      legend: false,
      scales: {
            yAxes: [{
                ticks: {
                    beginAtZero:true
                }
            }]
        }
    }
  end





  # GET /visits/1
  # GET /visits/1.json
  def show
  end


  # GET /visits/new
  def new
    @visit = Visit.new
  end

  # GET /visits/1/edit
  def edit
  end

  # POST /visits
  # POST /visits.json
  def create
    @visit = Visit.new(visit_params)

    respond_to do |format|
      if @visit.save
        format.html { redirect_to @visit, notice: 'Visit was successfully created.' }
        format.json { render :show, status: :created, location: @visit }
      else
        format.html { render :new }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visits/1
  # PATCH/PUT /visits/1.json
=begin
  def update
    respond_to do |format|
      if @visit.update(visit_params)
        format.html { redirect_to @visit, notice: 'Visit was successfully updated.' }
        format.json { render :show, status: :ok, location: @visit }
      else
        format.html { render :edit }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  # DELETE /visits/1
  # DELETE /visits/1.json
  def destroy
    @visit.destroy
    respond_to do |format|
      format.html { redirect_to visits_url, notice: 'Visit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit
      @visit = Visit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_params
      params.require(:visit).permit(:date_visit, :place_id)
    end
end
