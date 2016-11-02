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
      start_date  = !params[:start_date].empty? ? params[:start_date] : today
      end_date    = !params[:end_date].empty?   ? params[:end_date]   : today
      place_id    =  params[:place_id]

      #Get date parsed for comparison
      start_date_parse = Date.parse(start_date)
      end_date_parse   = Date.parse(end_date)
      #Get value splitted for unique comparison
      month_start = start_date_parse.month
      month_end   = end_date_parse.month
      year_start  = start_date_parse.year
      year_end    = end_date_parse.year
      #Get difference between two dates
      difference_of_day = end_date_parse - start_date_parse
      difference_of_year = year_end - year_start
      #Get an instance of start_date, used to loop and override date
      increment_date = Date.parse(start_date)
      #Get difference between two months
      difference_of_month = month_end - month_start

      labels = Array.new
      visit  = Array.new
      i = 0
      #Test if date selected isn't different of today, Then get visits every Hours
    if(start_date_parse <= date_now += 1.days || end_date_parse <= date_now += 1.days)

      if (start_date == today && end_date == today)
          puts "in today"
          datas = Visit.get_datas_for_hours(place_id,today,9,20)

          datas.each do |data|
            labels[i] = data['labels']
            visit[i]  = data['datas']
            i += 1
          end

    elsif ((!start_date.empty?) && end_date == today || (start_date == end_date && end_date == start_date))
      puts "in start_date"
      datas = Visit.get_datas_for_hours(place_id,start_date,9,20)

      datas.each do |data|
        labels[i] = data['labels']
        visit[i]  = data['datas']
        i += 1
      end

    elsif ((!end_date.empty?) && start_date == today)
      puts "in end_date"
      datas = Visit.get_datas_for_hours(place_id,end_date,9,20)

      datas.each do |data|
        labels[i] = data['labels']
        visit[i]  = data['datas']
        i += 1
      end
        #Test if datepicker left and right are did'nt equal
      else start_date != end_date && end_date != start_date

        if difference_of_day <= 30 && difference_of_year == 0
                puts "in days"
                datas = Visit.get_datas_for_days(place_id,start_date_parse,end_date_parse,month_start)
                datas.each do |data|
                  labels[i] = data['labels']
                  visit[i]  = data['datas']
                  i += 1
                end

            elsif difference_of_year == 0 && difference_of_day > 30

              if difference_of_month <= 5
                puts "in months <= 5"
                datas = Visit.get_datas_for_weeks(place_id,end_date_parse,increment_date,start_date_parse)
                datas.each do |data|
                  labels[i] = data['labels']
                  visit[i]  = data['datas']
                  i += 1
                end
              #Difference between two dates >5, Then get visits every months
              else
                puts "in months > 5"
                datas = Visit.get_datas_for_months(place_id,month_start,month_end)
                datas.each do |data|
                  labels[i] = data['labels']
                  visit[i]  = data['datas']
                  i += 1
                end
              end

            else difference_of_year != 0
                puts "in year different"
                datas = Visit.get_datas_for_years(place_id,start_date_parse,end_date_parse,increment_date)
                datas.each do |data|
                  labels[i] = data['labels']
                  visit[i]  = data['datas']
                  i += 1
                end
            end
         end #END if (start_date || end_date ) == today || start_date == end_date || end_date == start_date
         render :json => { :labels => labels , :datas => visit }
       else
         puts 'Erros : Wrong date given !'
       end
      end #END xhr request
    end # end def index

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
