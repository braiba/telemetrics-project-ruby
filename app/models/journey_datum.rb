class JourneyDatum < ActiveRecord::Base
  def to_latlong
    LatLong.new(latitude, longitude)
  end

  belongs_to :journey
end
