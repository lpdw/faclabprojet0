class VisitsController < ApplicationController
  before_action :set_visit, :only => [:show,:edit,:destroy,:update]

  #####################################################################################################################
  # GET /visits
  # GET /visits.json
  def index

    @visits = Visit.all
    @places = Place.all

    labels_hours = [9,10,11,12,13,14,15,16,17,18,19,20]
    #remplissage du label "labels_hours" depuis l'heure d'ouverture
    time_t = Time.now
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
      id_place = params[:id_place]

      place_id = params[:place_id]

      today = Date.today
      now = today.to_s(:db)
      nowTime = today.to_s

      # Si c'est initChart ou recup des données dont le filtre est date d'aujour
      if time_t.day.to_s == dayFilter && time_t.month.to_s == monthFilter && time_t.year.to_s == yearFilter

        #verif si on est en week
        week = today.saturday? || today.sunday?

############ Optimise this function to select data and charge the chartjs
            visitFromFinder = Visit.where(['date_visit like ? and place_id = ?', "%#{now}%", params[:place_id]])
            countVisit    = visitFromFinder.count
###################

        if week
          #recuperation du stat de la semaine
          labels = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi"]
          # datas = getDatas(type_labels)
          datas = [6,5,8,7,9]
        else
          #recuperation des stats à partir de l'instant T (connexion)
          time_t = Time.now
          labels = labels_hours
          # datas = getDatas(Date.today,"today",id_place,labels_hours)
          datas = [1,5,3,4,2,6,5,6,2,8,3,7]

          if countVisit
            # datas = [countVisit]
            labels = labels_hours
          end

          ### datas = getStat(type_labels) ###

          #visitFromFinder = Visit.where(["date_visit like ?", "%#{now}%"])
          #visitFromFinder = Visit.find(:all,, :conditions => ["date_visit like ?", "%#{now}%", "place_id = ?", params[:place_id]])
        end

        render :json => { :labels => labels , :datas => datas }
        # render :json => { :labels_weeks => labels_weeks , :labels_months => labels_months }
      else
        labels = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi"]
        # datas = getDatas(Date.today,"today",id_place)
        datas = [1,2,3,4,5,6,7,8,9]
        render :json => { :labels => labels , :datas => datas }
      end # fin filtre date aujourd'hui ou iniChart

    end # fin xhr?
  end

  #####################################################################################################################

  def getDatas(time,type_labels,id_place,labels_hours)

    datas = Array.new
    if type_labels == "today"
      # time = Time.now
      start_date = Date.parse(time.to_s)
      end_date = Date.parse(time.to_s)
      # Recuperation des données avec l'id de la place +
      i = 0
      hour_start = 9

      # labels_hours.each do |item|
        # datas[item] = item
        #recuperation des heures depuis l'ouverture

        # if datas[i] == nil
        #   datas.delete(datas[i])
        # else
        #   datas[i] =  Visit.where(
        #                                'place_id = ?
        #                                 AND DATE(date_visit) LIKE ?
        #                                 AND HOUR(date_visit) BETWEEN  ? and ?',
        #                                 id_place,
        #                                 time.to_s,
        #                                 labels_hours[item-1],
        #                                 labels_hours[item])
          # hour_start += 1
        # end
        # i += 1
      # end

      # datas = labels_hours.count

                          # time.strftime("%H")
                          # AND HOUR(date_visit) BETWEEN ? AND ?',
    else
      #Recuperation des données données de la semaine
      datas = Visit.where()
    end

    return datas
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
