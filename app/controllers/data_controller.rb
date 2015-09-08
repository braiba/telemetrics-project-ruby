class DataController < ApplicationController
  require 'csv'

  helper_method :current_journey, :has_journey?

  def upload
    # Empty controller action
  end

  def handle_upload
    uploaded_io = params[:journey_csv]
    if uploaded_io
      csv = CSV.parse(File.read(uploaded_io.path), :headers => true)

      journey = Journey.create_from_csv(csv, current_user.id)
      session[:journey_id] = journey.id

      redirect_to data_map_path and return
    end

    flash[:danger] = 'Upload failed'
    redirect_to data_upload_path
  end

  def map
    unless has_journey?
      flash[:warning] = 'No journey'
      redirect_to data_upload_path and return
    end
  end

  def stats
    unless has_journey?
      flash[:warning] = 'No journey'
      redirect_to data_upload_path and return
    end
  end

  def chart
    unless has_journey?
      flash[:warning] = 'No journey'
      redirect_to data_upload_path and return
    end
  end

  def select
    unless has_journey?
      redirect_to data_upload_path and return
    end
  end

  def select_journey
    session[:journey_id] = params[:id]
    redirect_to data_map_path
  end

  # Returns the current journey (if any).
  def current_journey
    @current_journey ||= Journey.find_by(id: session[:journey_id])
  end

  # Returns true if the user has a current journey, false otherwise.
  def has_journey?
    !current_journey.nil?
  end
end
