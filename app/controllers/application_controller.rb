class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_participant

  def self.not_found
      raise ActionController::RoutingError.new('Not Found')
  end

  def record_not_found
      raise ActionController::RoutingError.new('Not Found')
  end

  private

    @last_pid

    def current_participant
      if !session[:participant_id].nil?
        if @last_pid != session[:participant_id]
          begin
            @current_participant = Participant.find(session[:participant_id])
          rescue ActiveRecord::RecordNotFound => e
            #@flash[:error] = "An error occured while retrieving the login information"
            raise Exception, e
          end
          @last_pid = session[:participant_id]
        end
      else
        @last_pid = nil
      end
      return @current_participant
    end

end
