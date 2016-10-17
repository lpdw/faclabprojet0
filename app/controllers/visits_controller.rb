class VisitsController < ApplicationController
  before_action :set_visit, :only => [:show,:edit,:destroy,:update]

  #####################################################################################################################
  # GET /visits
  # GET /visits.json
  def index

    @visits = Visit.all
    @places = Place.all

    labels_hours = Array.new
    #remplissage du label "labels_hours" depuis l'heure d'ouverture
    time_t = Time.now
    hour = 8
    while hour < time_t.hour
      hour += 1
      labels_hours.push(hour.to_s + "h")
    end

    labels = Array.new

    #Filtre par mois
    # labels_months = ["Jan", "Fevr", "Mars", "Avril", "Mai", "Juin", "Juillet","Aout","Sept","Oct","Nov","Dec"]
    #Filtre par semaine
    # labels_weeks = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi"]

    ############################################################################
     #Si on reçoit une requete Ajax afin de charger les données pour la chartJS
    ############################################################################
    if request.xhr?

      dayFilter = params[:dayFilter]
      monthFilter = params[:monthFilter]
      yearFilter = params[:yearFilter]
      place_name = params[:place_name]

      # Si c'est initChart ou recup des données dont le filtre est date d'aujour
      if time_t.day.to_s == dayFilter && time_t.month.to_s == monthFilter && time_t.year.to_s == yearFilter
        #verif si on est en week
        today = Date.today
        week = today.saturday? || today.sunday?

        if week
          #recuperation du stat de la semaine
          labels = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi"]
          ### datas = getStat(type_labels) ###
          datas = [6,5,8,7,9]
        else
          #recuperation des stats à partir de l'instant T (connexion)
          time_t = Time.now
          labels = labels_hours
          ### datas = getStat(type_labels) ###
          datas = [1,5,3,4,7]
        end

        render :json => { :labels => labels , :datas => datas }
        # render :json => { :labels_weeks => labels_weeks , :labels_months => labels_months }

      else
        labels = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi"]
        datas = [6,5,8,7,9]
        render :json => { :labels => labels , :datas => datas }

      end # fin filtre date aujourd'hui ou iniChart
    end # fin xhr?
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
