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
		lat = @search['geometry']['location']['lat']
		lon = @search['geometry']['location']['lng']
		# @timezone = Eztz.timezone(lat: @search['geometry']['location']['lat'], lng: @search['geometry']['location']['lng'])
		@timezone = Timezone::Zone.new :latlon => [lat,lon]
		if session[:date]
			@date = DateTime.parse(session[:date]).in_time_zone(@timezone.zone).midnight
		else
			if params[:date][:date] != ""
				@date = DateTime.parse(params[:date][:date]).in_time_zone(@timezone.zone).midnight
			else
				@date = DateTime.now.in_time_zone(@timezone.zone).midnight
			end
			@times = params[:times]
		end
		puts "First Date ========================"
		puts @date

		# Get Timezone
		@forecast = Forecast::IO.forecast(
			lat,
			lon,
			time: @date.midnight.to_i
		)

		@yesterday = Forecast::IO.forecast(
			lat,
			lon,
			time: (@date.midnight-1.day).to_i
		)

		puts "Second Date ========================"
		puts @date


		@forecast.hourly.data.each.with_index do |f, index|
			puts '----- Index ' + index.to_s
			puts DateTime.strptime(f.time.to_s,'%s').to_formatted_s(:short)
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