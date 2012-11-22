class WriteupsController < ApplicationController

  def index
    @writeups = Solution.where("challenge_id = #{params[:challenge_id]}").all
  end

end
