class JourneyDatum < ActiveRecord::Base
  require 'floow/lat_long'

  def to_lat_long
    Floow::LatLong.new(latitude, longitude)
  end

  belongs_to :journey
end
