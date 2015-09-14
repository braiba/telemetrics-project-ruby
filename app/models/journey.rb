class Journey < ActiveRecord::Base
  require 'floow/lat_long'
  require 'floow/sql_insert_batcher'

  belongs_to :user

  def self.create_from_csv(csv, user_id)
    journey = Journey.new

    journey.user_id = user_id

    journey.save

    row_index  = 0
    distance   = 0
    prev_point = nil

    column_names       = %w(journey_id row_index distance timestamp speed altitude latitude longitude)
    sql_insert_batcher = Floow::SqlInsertBatcher.new('journey_datum', column_names)

    csv.each do |row|
      millis    = row['millis'].to_f
      speed     = row['speed'].to_f
      altitude  = row['altitude'].to_f
      latitude  = row['latitude'].to_f
      longitude = row['longitude'].to_f

      curr_point = Floow::LatLong.new(latitude, longitude)

      if prev_point != nil
        distance = prev_point.distance curr_point
      end

      sql_insert_batcher.push [
        journey.id,
        row_index,
        distance,
        millis,
        speed,
        altitude,
        latitude,
        longitude,
      ]

      prev_point = curr_point

      row_index += 1
    end

    sql_insert_batcher.flush

    return journey
  end

  def start_timestamp
    @start_timestamp = Time.at((journey_datums.minimum(:timestamp) || 0) / 1000).to_datetime
  end

  def end_timestamp
    @end_timestamp ||= Time.at((journey_datums.maximum(:timestamp) || 0) / 1000).to_datetime
  end

  def total_distance
    @total_distance ||= journey_datums.sum(:distance)
  end

  def max_speed
    @max_speed ||= journey_datums.maximum(:speed)
  end

  def average_speed
    @average_speed ||= journey_datums.average(:speed)
  end

  def max_altitude
    @max_altitude ||= journey_datums.maximum(:altitude)
  end

  def min_altitude
    @min_altitude ||= journey_datums.minimum(:altitude)
  end

  def average_altitude
    @average_altitude ||= journey_datums.average(:altitude)
  end

  def highest_point
    if @highest_point
      return @highest_point
    end

    journey_datums.each do |datum|
      if datum.altitude == max_altitude
        @highest_point = Floow::LatLong.new(datum.latitude, datum.longitude)
        break
      end
    end

    @highest_point
  end

  def first_point
    journey_datums.first.to_lat_long
  end

  def last_point
    journey_datums.last.to_lat_long
  end

  def central_point
    if @central_point
      return @central_point
    end

    latitude  = (journey_datums.maximum(:latitude) + journey_datums.minimum(:latitude)) / 2
    longitude = (journey_datums.maximum(:longitude) + journey_datums.minimum(:longitude)) / 2

    @central_point = Floow::LatLong.new(latitude, longitude)
  end

  def formatted_timespan
    start_date = start_timestamp.strftime('%d/%m/%Y')
    end_date   = end_timestamp.strftime('%d/%m/%Y')
    start_time = start_timestamp.strftime('%H:%M')
    end_time   = end_timestamp.strftime('%H:%M')

    start_date + ' ' + start_time + ' - ' + (end_date != start_date ? end_date + ' ' : '') + end_time
  end

  # Returns a path string that can be used to describe the journey to the Google Maps API
  def gmaps_path
    points = []

    # we can't include every point, because there's a limit on how long a query string can be
    max_points = 50
    step_size  = [(journey_datums.length / max_points).floor, 1].max
    journey_datums.where('row_index % ' + step_size.to_s + ' = 0').each do |journey_datum|
      points.push journey_datum.to_lat_long.to_coords
    end

    # always include the last point
    points.push last_point.to_coords

    points.join('|')
  end

  has_many :journey_datums
end
