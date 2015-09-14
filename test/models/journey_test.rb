require 'test_helper'

class JourneyTest < ActiveSupport::TestCase

  def setup
    @journey = Journey.find(1)
  end

  test 'highest point' do
    lat_long = @journey.highest_point
    assert_in_delta lat_long.latitude, 51.5056, 0.0001
    assert_in_delta lat_long.longitude, 0.0756, 0.0001
  end

  test 'lowest altitude' do
    assert_in_delta 5.00, @journey.min_altitude, 0.0001
  end

  test 'central point stays the same' do
    first  = @journey.central_point
    second = @journey.central_point
    assert_same first, second
  end

  test 'highest point stays the same' do
    first  = @journey.highest_point
    second = @journey.highest_point
    assert_same first, second
  end
end
