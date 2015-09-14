class DataController < ApplicationController
  require 'csv'

  before_filter :require_journey

  helper_method :current_journey, :has_journey?, :journeys_available?

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
    # Empty controller action
  end

  def stats
    # Empty controller action
  end

  def chart
    # Empty controller action
  end

  def select
    # Empty controller action
  end

  def select_journey
    session[:journey_id] = params[:id]
    redirect_to data_map_path
  end

  protected

  # Returns the current journey (if any).
  def current_journey
    @current_journey ||= Journey.find_by(id: session[:journey_id])
  end

  # Returns true if the user has a current journey, false otherwise.
  def has_journey?
    !current_journey.nil?
  end

  def journeys_available?
    !current_user.journeys.nil?
  end

  private
  def require_journey
    journey_actions = %w(map stats chart)
    if journey_actions.include? action_name and !has_journey?
      flash[:warning] = 'No journey'
      redirect_to data_upload_path
    end
  end
end
