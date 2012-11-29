class SessionsController < ApplicationController

  def new
    read = YAML.load(File.open("#{::Rails.root}/config/oauth.yml").read)
    @services = read.keys
  end

  def destroy
    flash[:notice] = "You are now logged out."
    reset_session
    redirect_to root_url
  end

  def create
    auth = request.env["omniauth.auth"]
    participant = Participant.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if participant.nil?
      participant = Participant.create_with_omniauth(auth)
      SystemMailer.welcome(participant)
    end

    reset_session
    session[:participant_id] = participant.id
    flash[:notice] = "Login successful :)"
    redirect_to root_url
  end

  def failure
    flash[:error] = "Error during authentication :("
    reset_session
    redirect_to root_url
  end


end
