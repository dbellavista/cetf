class ParticipantsController < ApplicationController

  def index
    @participants = Participant.order("points DESC").all
  end

  def new
      flash[:error] = "Direct registration is no more supported"
    redirect_to root_url
  end

  def edit
    @owner = is_owner? params[:id].to_i
    if !@owner
      flash[:error] = "You don't have the permission to do that :\\"
      redirect_to root_url
    end
    @participant = current_participant
  end

  def show
    @participant = Participant.find(params[:id])
    @owner = is_owner? params[:id].to_i
  end

  def create
    @participant = Participant.new()
    @participant.name = params[:participant][:name]
    @participant.points = 0
    @participant.save!
    redirect_to participants_path
  end

  def update
    if !is_owner? params[:id].to_i
      flash[:error] = "An error occurred while updating the profile information"
      redirect_to root_url
    end
    participant = current_participant
    participant.name = params[:participant][:name]
    participant.save!
    redirect_to participants_path
  end

  def destroy
    if !is_owner? params[:id].to_i
      flash[:error] = "An error occurred while deleting the profile"
      redirect_to root_url
    end
    participant = current_participant
    participant.destroy
    reset_session
    redirect_to root_url
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end

  private

  def is_owner?(id)
    !current_participant.nil? and current_participant.id == id
  end
end
