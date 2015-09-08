class LatLong
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

  protected
  def latitude_to_s(latitude)
    angle_to_s(latitude) + (latitude < 0 ? 'W' : 'E')
  end

  def latitude_to_html(latitude)
    (angle_to_html(latitude) + (latitude < 0 ? 'W' : 'E')).html_safe
  end

  def longitude_to_s(longitude)
    angle_to_s(longitude) + (longitude < 0 ? 'S' : 'N')
  end

  def longitude_to_html(longitude)
    (angle_to_html(longitude) + (longitude < 0 ? 'S' : 'N')).html_safe
  end

  def angle_to_s(angle)
    dms = angle_to_dms(angle)
    dms[:degrees].to_s + "\u00B0" + dms[:minutes].to_s + "\u2019" + dms[:seconds].to_s + "\u201D"
  end

  def angle_to_html(angle)
    dms = angle_to_dms(angle)
    (dms[:degrees].to_s + '&#0176;' + dms[:minutes].to_s + '&#8217;' + dms[:seconds].to_s + '&#8221;').html_safe
  end

  def angle_to_dms (angle)
    degrees = angle.floor
    angle = 60 * (angle - degrees)
    minutes = angle.floor
    angle = 60 * (angle - minutes)
    seconds = (angle * 10).round / 10

    {
        degrees: degrees,
        minutes: minutes,
        seconds: seconds,
    }
  end
end