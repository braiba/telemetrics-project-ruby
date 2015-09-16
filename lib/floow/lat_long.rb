module Floow
  class LatLong
    require 'Haversine'

    def initialize(latitude, longitude)
      @latitude = latitude
      @longitude = longitude
    end

    def latitude
      @latitude
    end

    def longitude
      @longitude
    end

    def to_coords
      @latitude.to_s + ',' + @longitude.to_s
    end

    def to_s
      '(' + latitude_to_s(@latitude) + ',' + longitude_to_s(@longitude) + ')'
    end

    def to_html
      ('(' + latitude_to_html(@latitude) + ',' + longitude_to_html(@longitude) + ')').html_safe
    end

    def distance (dest)
      Haversine.distance(latitude, longitude, dest.latitude, dest.longitude) * 1000
    end

    protected
    def latitude_to_s(latitude)
      angle_to_s(latitude.abs) + (latitude >= 0 ? 'N' : 'S')
    end

    def latitude_to_html(latitude)
      (angle_to_html(latitude.abs) + (latitude >= 0 ? 'N' : 'S')).html_safe
    end

    def longitude_to_s(longitude)
      angle_to_s(longitude.abs) + (longitude >= 0 ? 'E' : 'W')
    end

    def longitude_to_html(longitude)
      (angle_to_html(longitude.abs) + (longitude >= 0 ? 'E' : 'W')).html_safe
    end

    def angle_to_s(angle)
      format_angle(angle, "\u00B0", "\u2019", "\u201D").html_safe
    end

    def angle_to_html(angle)
      format_angle(angle, '&#0176;', '&#8217;', '&#8221;').html_safe
    end

    def format_angle(angle, deg_sym, min_sym, sec_sym)
      dms = angle_to_dms(angle)
      dms[:degrees].to_s + deg_sym + ('%02d' % dms[:minutes]) + min_sym + ('%04.1f' % dms[:seconds]) + sec_sym
    end

    def angle_to_dms (angle)
      degrees = angle.floor
      angle = 60 * (angle - degrees)
      minutes = angle.floor
      angle = 60 * (angle - minutes)
      seconds = angle

      {
          degrees: degrees,
          minutes: minutes,
          seconds: seconds,
      }
    end
  end
end