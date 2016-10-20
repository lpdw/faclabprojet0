class VisitsController < ApplicationController
  before_action :set_visit, :only => [:show,:edit,:destroy,:update]

  #####################################################################################################################
  # GET /visits
  # GET /visits.json
  def index

    @visits = Visit.all
    @places = Place.all

    labels_hours = [9,10,11,12,13,14,15,16,17,18,19,20]
    labels_months = ["Jan", "Fevr", "Mars", "Avril", "Mai", "Juin", "Juillet","Aout","Sept","Oct","Nov","Dec"]
    labels_weeks = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi"]

    time_t = Time.now
    today = Date.today

    chart_labels = Array.new

    ############################################################################
    if request.xhr?

      # get datas from params
      dayFilter = params[:dayFilter]
      monthFilter = params[:monthFilter]
      yearFilter = params[:yearFilter]
      id_place = params[:id_place]

      # check if params['start_date'] == params['end_date']
      #       and params['start_date'] == dateToday
      #       and params['end_date'] == dateToday
      #       Then getStatForToday

      #if init or we want a datas for today
      if time_t.day.to_s == dayFilter && time_t.month.to_s == monthFilter && time_t.year.to_s == yearFilter

        #check if weeks day
        week = today.saturday? || today.sunday?

        if week
          chart_labels = labels_weeks
          # datas = getDatas(type_labels)
          datas = [6,5,8,7,9]
        else
          #recovery stats at the time of connection (time T)
          chart_labels = labels_hours
          # datas = getDatas(Date.today,"today",id_place,labels_hours)
          datas = [1,5,3,4,2,6,5,6,2,8,3,7]
          datas = getDatas()
        end ### end if week

        render :json => { :labels => chart_labels , :datas => datas }
      else
        chart_labels = labels_weeks
        # datas = getDatas(Date.today,"today",id_place)
        datas = [1,2,3,4,5,6,7,8,9]

        render :json => { :labels => chart_labels , :datas => datas }
      end ### end if user want datas with start_date and end_date

    end # end request xhr?
  end

  #####################################################################################################################

  def getDatas(time,type_labels,id_place,labels_hours)

    ############ Optimise this function to select data and charge the chartjs
                # visitFromFinder = Visit.where(['date_visit like ? and place_id = ?', "%#{now}%", params[:place_id]])
                # countVisit    = visitFromFinder.count
    ###################
    # if countVisit
      # datas = [countVisit]
    #   labels = labels_hours
    # end

    datas = Array.new

    if type_labels == "today"
      hour_start = 9

        Visit.where(
                     'place_id = ?
                      AND DATE(date_visit) LIKE ?
                      AND HOUR(date_visit) BETWEEN  ? and ?',
                      id_place,
                      time.to_s,
                      labels_hours[item-1],
                      labels_hours[item]
                    )
      else
      #Recuperation des données données de la semaine a partir du filtre
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
