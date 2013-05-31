class FrontendController < ApplicationController
	require 'forecast_io'
	require 'ostruct'
	require 'tzinfo'
	require 'time'
	require 'date'


	def index

	end
	def results
		@search = Geocoder.search(params[:location])
		if params[:times] && params[:date]
			session.delete(:times)
			session.delete(:date)
		end
		if @search.size > 1
			session[:results] = @search
			session[:times] = params[:times]
			if !params[:date] || params[:date][:date] == ""
				session[:date] = DateTime.now.to_s
			else
				session[:date] = params[:date][:date]
			end
			redirect_to :action => :multiple_results
			return false
		end

		@search = @search.first.data
		# @timezone = Eztz.timezone(lat: @search['geometry']['location']['lat'], lng: @search['geometry']['location']['lng'])
		if session[:date]
			@date = DateTime.parse(session[:date]).midnight.utc
		else
			if params[:date][:date] != ""
				@date = DateTime.parse(params[:date][:date]).midnight.utc
			else
				@date = DateTime.now.midnight.utc
			end
			@times = params[:times]
		end
		puts "First Date ========================"
		puts @date

		# Get the Forecasts for the selected dat, and the previous
		@forecast = Forecast::IO.forecast(
			@search['geometry']['location']['lat'],
			@search['geometry']['location']['lng'],
			time: @date
		)
		@yesterday = Forecast::IO.forecast(
			@search['geometry']['location']['lat'],
			@search['geometry']['location']['lng'],
			time: @date-1.day
		)

				@date.new_offset(@forecast.offset).midnight

		puts "Second Date ========================"
		puts @date

		params[:times].each do |array, t| 
				hour = t['ampm'] == 'PM' ? t['h'].to_i + 12 : t['h'].to_i 
				time = @date.change({:hour => hour}).to_time 
				time = Time.new(time.year, time.month, time.day, time.hour, time.min, time.sec).utc.round(1.hour) 
				today = @forecast.hourly.data.select{ |x| x['time'] == time.to_i }.first 
				puts "Loop Time =========================="
				puts time
				puts time.to_i
				puts today
			end
		@gear = OpenStruct.new(:sunglasses => false,:goggles => false,:rain => false,:wind => false,:warm => false)

	end
	def multiple_results
		@locations = session[:results]
	end


	def adjust_time time, time_zone="America/Los_Angeles"
	    return TZInfo::Timezone.get(time_zone).utc_to_local(time.utc)
	end
end