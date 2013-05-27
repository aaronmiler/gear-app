class FrontendController < ApplicationController
	require 'forecast_io'
	require 'ostruct'
	require 'tzinfo'


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
		@timezone = Eztz.timezone(lat: @search['geometry']['location']['lat'], lng: @search['geometry']['location']['lng'])
		if session[:date]
			@date = DateTime.parse(session[:date]).new_offset(((@timezone.rawOffset + @timezone.dstOffset)/60/60)/24).midnight
		else
			if params[:date][:date] != ""
				@date = DateTime.parse(params[:date][:date]).new_offset(((@timezone.rawOffset + @timezone.dstOffset)/60/60)/24).midnight
			else
				@date = DateTime.now.new_offset(((@timezone.rawOffset + @timezone.dstOffset)/60/60)/24).midnight
			end
			@times = params[:times]
		end

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
		@gear = OpenStruct.new(:sunglasses => false,:goggles => false,:rain => false,:wind => false,)
		render text: ap(@forecast)
	end
	def multiple_results
		@locations = session[:results]
	end


	def adjust_time time, time_zone="America/Los_Angeles"
	    return TZInfo::Timezone.get(time_zone).utc_to_local(time.utc)
	end
end