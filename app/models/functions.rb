class Functions < ActiveRecord::Base
  # attr_accessible :title, :body
  def self.getForecast(lat,lon, time)
  	return Forecast::IO.forecast(
		lat,
		lon,
		time: time.to_i
	)
  end
  def self.getLocation(loc)
  	unless loc['address_components'].select{ |x| x['types'] == ['administrative_area_level_1','political']}  		
  		@place = loc['address_components'].select{ |x| x['types'] == ['locality','political']}.first['short_name'] + ", "
  		@place += loc['address_components'].select{ |x| x['types'] == ['administrative_area_level_1','political']}.first['short_name']
  	else
  		@place = loc['formatted_address']
  	end
  	return @place.to_s
  end
end
