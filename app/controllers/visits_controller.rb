class VisitsController < ApplicationController
  before_action :set_visit, :only => [:show,:edit,:destroy,:update]

  #####################################################################################################################
  # GET /visits
  # GET /visits.json
  def index

    @visits = Visit.all
    @places = Place.all

    respond_to do |format|
      format.html
      format.csv { render plain: @visits.to_csv }
    end

    labels_hours = [9,10,11,12,13,14,15,16,17,18,19,20]
    labels_months = ["Jan", "Fevr", "Mars", "Avril", "Mai", "Juin", "Juillet","Aout","Sept","Oct","Nov","Dec"]
    labels_weeks = ["Lundi","Mardi","Mercredi","Jeudi","Vendredi"]

    time_t = Time.now
    date_now = Date.today
    today    = date_now.to_s(:db)

    chart_labels = Array.new

    ############################################################################
    if request.xhr?

      # get datas from params
      start_date = params[:start_date]
      end_date = params[:end_date]

      place_id = params[:place_id]

      # check if params['start_date'] == params['end_date']
      #       and params['start_date'] == dateToday
      #       and params['end_date'] == dateToday
      #       Then getStatForToday

      #if init or we want a datas for today
      if start_date || end_date == today

        #check if weeks day
        week = date_now.saturday? || date_now.sunday?

        if week
          chart_labels = labels_weeks
          # datas = getDatas(type_labels)
          datas = [6,5,8,7,9]
        else
          #recovery stats at the time of connection (time T)
          chart_labels = labels_hours
          # datas = getDatas(Date.today,"today",id_place,labels_hours)
          #datas = [1,5,3,4,2,6,5,6,2,8,3,7]
          datas = getDatas(start_date,end_date,place_id,today)

        end ### end if week

        render :json => { :labels => chart_labels , :datas => datas }
      else
        chart_labels = labels_weeks
        # datas = getDatas(Date.today,"today",id_place)
        datas = [1,2,3,4,5]

        render :json => { :labels => chart_labels , :datas => datas }
      end ### end if user want datas with start_date and end_date

      puts datas.inspect
    end # end request xhr?


  end

  #####################################################################################################################

  def getDatas(start_date,end_date,place_id,today)

    ############ Optimise this function to select data and charge the chartjs
                # visitFromFinder = Visit.where(['date_visit like ? and place_id = ?', "%#{now}%", params[:place_id]])
                # countVisit    = visitFromFinder.count
    ###################
    # if countVisit
      # datas = [countVisit]
    #   labels = labels_hours
    # end

    # It's impossible to define or request a visit who did'nt append - this is why we should disable year/month/day if is different from today

    datas = Array.new
    hour_include = []
    test = Array.new
    if (start_date || end_date) == today || (start_date && end_date) == today || (start_date == end_date) || (end_date == start_date)
      hour_start = 9
      #hour_end   = 10
      #minute_start = 00
      #minute_end = 59
      i = 0
      while hour_start <= 20 do
        datas[i] = Visit.where(
                     'place_id = ?
                      AND DATE(date_visit) = ? AND HOUR(date_visit) = ?',
                      place_id,
                      today,
                      hour_start,
                    ).count
                  hour_start += 1
                  #hour_end += 1
                  #datas.each do |d|
                    puts datas.inspect
                  #end
                  i += 1
                end


                  #logger.debug(data.inspect)

      else
      #Recuperation des données données de la semaine a partir du filtre
      datas = Visit.where('place_id = ?
                            AND DATE(date_visit) BETWEEN ? AND ?',
                            place_id,
                            start_date,
                            end_date
                          ).select("date_visit")
        datas.each do |d|
        hour_include = d["date_visit"]
        hour_split   = hour_include.strftime("%H:%M").count(hour_include)
      if hour_split >= "09:00" && hour_split <= "09:59"
          from_end_nine_hour = hour_include
          counted = datas.length()

          end


      end

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
