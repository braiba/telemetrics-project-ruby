class Journey < ActiveRecord::Base
  require 'geo-distance'

  belongs_to :user

  def self.create_from_csv(csv, user_id)
    journey = Journey.new

    journey.user_id = user_id

    journey.save

    row_index      = 0
    distance       = 0
    prev_latitude  = nil
    prev_longitude = nil

    connection = ActiveRecord::Base.connection
    logger     = ActiveRecord::Base.logger

    prev_log_level = logger.level
    logger.level   = Logger::INFO

    column_names   = %w(journey_id row_index distance timestamp speed altitude longitude latitude)
    sql_inserts    = []
    max_batch_size = 500

    csv.each do |row|

      if prev_latitude != nil then
        distance = 0.1
        #distance = GeoDistance::Haversine.geo_distance(
        #    row['latitude'],
        #    row['longitude'],
        #    prev_latitude,
        #    prev_longitude
        #).to_meters
      end

      sql_insert_values = [
        journey.id,
        row_index,
        distance,
        row['millis'].to_f,
        row['speed'].to_f,
        row['altitude'].to_f,
        row['longitude'].to_f,
        row['latitude'].to_f,
      ]

      sql_inserts.push '(' + sql_insert_values.join(', ') + ')'

      if sql_inserts.length == max_batch_size
        sql = 'INSERT INTO journey_data (' + column_names.join(', ') + ') VALUES ' + sql_inserts.join(', ') + ';'
        connection.execute sql

        sql_inserts = []
      end

      prev_latitude  = row['latitude']
      prev_longitude = row['longitude']

      row_index += 1
    end

    if sql_inserts.length != 0
      sql = 'INSERT INTO journey_data (' + column_names.join(', ') + ') VALUES ' + sql_inserts.join(', ') + ';'
      connection.execute sql
    end

    logger.level = prev_log_level

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
    @max_altitude ||= journey_datums.minimum(:altitude)
  end

  def average_altitude
    @max_altitude ||= journey_datums.average(:altitude)
  end

  def highest_point
    if @highest_point
      return @highest_point
    end

    # DEBUG
    latitude = journey_datums.maximum(:latitude)
    longitude = journey_datums.maximum(:longitude)

    @highest_point = LatLong.new(latitude, longitude)
  end

  def first_point
    journey_datums.first.to_latlong
  end

  def last_point
    journey_datums.last.to_latlong
  end

  def central_point
    if @central_point
      return @central_point
    end

    latitude = (journey_datums.maximum(:latitude) + journey_datums.minimum(:latitude)) / 2
    longitude = (journey_datums.maximum(:longitude) + journey_datums.minimum(:longitude)) / 2

    @central_point = LatLong.new(latitude, longitude)
  end

  def formatted_timespan
    start_date = start_timestamp.strftime('%d/%m/%Y')
    end_date   = end_timestamp.strftime('%d/%m/%Y')
    start_time = start_timestamp.strftime('%H:%M')
    end_time   = end_timestamp.strftime('%H:%M')

    start_date + ' ' + start_time + ' - ' + (end_date != start_date ? end_date + ' ' : '') + end_time
  end

  def gmaps_path
    points = []

    # we can't include every point, because there's a limit on how long a query string can be
    max_points = 50
    step_size = [(journey_datums.length / max_points).floor, 1].max
    journey_datums.where('row_index % ' + step_size.to_s + ' = 0').each do |journey_datum|
      points.push journey_datum.to_latlong.to_coords
    end

    # always include the last point
    points.push last_point.to_coords

    points.join('|')
  end

  has_many :journey_datums
end
