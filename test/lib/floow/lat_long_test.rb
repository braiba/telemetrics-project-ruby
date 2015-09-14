require 'test_helper'

class LatLongTest < ActiveSupport::TestCase
  require 'floow/lat_long'

  test 'should convert lat long to string' do
    [
        #0: Simple zero test
        [0, 0, "(0\u00B000\u201900.0\u201DN,0\u00B000\u201900.0\u201DE)"],
        #1: NW point - Big Ben, England (Source: Google Maps)
        [51.5008, -0.1247, "(51\u00B030\u201902.9\u201DN,0\u00B007\u201928.9\u201DW)"],
        #2: SW point - Christ the Redeemer, Brazil (Source: Google Maps)
        [-22.9519, -43.2106, "(22\u00B057\u201906.8\u201DS,43\u00B012\u201938.2\u201DW)"],
        #3: NE point - Arc de Triomphe, France (Source: Google Maps)
        [48.8738, 2.2950, "(48\u00B052\u201925.7\u201DN,2\u00B017\u201942.0\u201DE)"],
        #4: SE point - Sydney Opera House, Australia (Source: Google Maps)
        [-33.8587, 151.2140, "(33\u00B051\u201931.3\u201DS,151\u00B012\u201950.4\u201DE)"],
        #5: Edge Case - South Pole, Antarctica (Source: Google Maps)
        [-90, 0, "(90\u00B000\u201900.0\u201DS,0\u00B000\u201900.0\u201DE)"],
        #6: Edge Case - North Pole, Arctic (Source: Google Maps)
        [90, 0, "(90\u00B000\u201900.0\u201DN,0\u00B000\u201900.0\u201DE)"],
    ].each do |latitude, longitude, expected_s|
      assert_equal(expected_s, Floow::LatLong.new(latitude, longitude).to_s)
    end
  end

  test 'distance should be calculated between two points' do
    [
      #0: Simple 0,0 -> 0,0 test
      [0, 0, 0, 0, 0],
      #1: Empire State Building to Alcatraz (Source: http://www.movable-type.co.uk/scripts/latlong.html)
      [40.7484, -73.9857, 37.8267, -122.4233, 4128000],
    ].each do |from_lat, from_long, to_lat, to_long, expected_distance|
      from = Floow::LatLong.new(from_lat, from_long)
      to   = Floow::LatLong.new(to_lat, to_long)
      assert_in_delta(expected_distance, from.distance(to), 1000)
    end
  end
end
