class VisitsController < ApplicationController
  before_action :set_visit, :only => [:show,:edit,:destroy,:update]


  #####################################################################################################################
  # GET /visits
  # GET /visits.json
  def index
    @visits = Visit.all

    @places = Place.all

    labels_hours = Array.new
    time_t = Time.now

    #remplissage du label "labels_hours" depuis l'ouverture
    hour = 9
    count_hour_from_open = 0
    while hour < time_t.hour
      hour += 1
      count_hour_from_open += 1
      labels_hours.push(hour.to_s + "h")
    end

    #création du tableau qui va contenir les données avec comme taille le nombre d'heure compter depuis l'ouverture
    datas_chart = Array.new(count_hour_from_open)

    labels_weeks = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi"]
    labels_months = ["Jan", "Fevr", "Mars", "Avril", "Mai", "Juin", "Juillet","Aout","Sept","Oct","Nov","Dec"]

    #
    # STAT DE BASE
    # => on affiche les stats à l'instant T
    # => sinon celui de la semaine
    #
    today = Date.today
    week = today.saturday? || today.sunday?

    if week
      #recuperation du stat de la semaine
      type_labels = "week"
      monday = "date de debut de la semaine => Lundi"
      friday = "date de fin de semaine => Vendredi"
      datas_chart = [5,9,7,1,2]
    else
      type_labels = "day"
      date_today = (Date.today).strftime("%d/%m/%Y")
      #recuperation des stats à partir de l'instant T (connexion)
      time_t = Time.now
      #datas_db = get_data_Stat time_t.hour
      datas_db = [1,5,3,4,2,6,5,6,2,8,3,7]

      for i in 0..datas_chart.length-1
        #set les datas de la stat graphique à partir des datas de la bdd
        datas_chart[i] = datas_db[i]
      end
    end


    if type_labels == "day"
      labels = labels_hours
    else
      labels = labels_weeks
    end


    @data = {
      labels: labels,
      datasets: [
        {
            label: " nb personne ",
            backgroundColor: "#83D6DE",
            borderColor: "#1DABB8",
            data: datas_chart
        }
      ]
    }
    @options = {
      title: {
            display: true,
            text: 'STATISTIQUES DU ' + date_today,
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
  #####################################################################################################################




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
