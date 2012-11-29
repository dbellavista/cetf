class ChallengesController < ApplicationController

  def index
    @challenges = Challenge.order("points DESC").all
    @logged = logged?
  end

  def writeup
    if !logged?
      redirect_to challenge_path(params[:id])
    end
    solver = current_participant
    @challenge = Challenge.find(params[:id])
    solution = @challenge.solutions.where('participant_id = ?', current_participant.id).first
    if !solution.nil?
      solution.writeup = params[:solution][:writeup]
      solution.save!
      flash[:notice] = "Your writeup has been saved!"
    else
      flash[:error] = "You haven't solved this challenge!! D:"
    end
    redirect_to challenge_path(@challenge.id)
  end

  def writeups
    @challenge = Challenge.find(params[:id])
    @solutions = @challenge.solutions.where('writeup <> ""')
  end

  def solve
    if !logged?
      flash[:error] = "You must be logged in order to solve challenges."
      redirect_to challenge_path(params[:id])
    end
    @challenge = Challenge.find(params[:id])
    solver = current_participant
    if @challenge.author === solver
      flash[:error] = "You have created the challenge!! :/"
    elsif @challenge.solvers.include? solver
      flash[:error] = "Yo have already solved this challenge!! D:"
    elsif @challenge.solution === params[:solution][:solution]
      solver.points += @challenge.points
      solver.save!
      @challenge.solvers << solver
      @challenge.save!
      if !@challenge.author.nil? do
        SystemMailer.challenge_solved(@challenge.author, @challenge)
      end
      flash[:notice] = "Congratz #{solver.name}!!! +#{@challenge.points} points! :D"
    else
      flash[:error] = "Wrong solution... :("
    end
    redirect_to challenge_path(@challenge.id)
  end

  def show
    id = params[:id]
    @challenge = Challenge.find(id)
    @participant = current_participant

    @own = !@participant.nil? and !@challenge.author.nil? and @challenge.author.id == current_participant.id

    @there_are_writeups = !@challenge.solutions.where('writeup <> ""').empty?

    @solved = @challenge.solvers.include? current_participant
    @logged = logged?
    if @solved
      @solution = @challenge.solutions.where('participant_id = ?', current_participant.id).first
      @there_are_other_writeups = !@challenge.solutions.where('writeup <> "" AND participant_id <> ?', current_participant.id).empty?
    end

  end

  def destroy
    if !logged?
      redirect_to challenge_path(params[:id])
    end

    @challenge = Challenge.find(params[:id])
    if @challenge.author.nil? or @challenge.author.id != current_participant.id
      flash[:error] = "You must be the author in order to delete the challenge"
      redirect_to challenges_path(params[:id])
    end
    points = @challenge.points
    old_solvers = @challenge.solvers

    old_solvers.each do |s|
      s.points -= points
      s.points = 0 unless s.points > 0
      s.save
    end

    author = @challenge.author
    if !author.nil?
      author.points -= Challenge.pointsPerChallengeInsertion
      author.points = 0 unless author.points > 0
      author.save
    end

    @challenge.destroy

    flash[:notice] = "Challenge '#{@challenge.name}' deleted."
    redirect_to challenges_path
  end

  def edit
    if !logged?
      redirect_to challenge_path(params[:id])
    end
    @challenge = Challenge.find(params[:id])
    if @challenge.author.nil? or current_participant.id != @challenge.author.id
      redirect_to challenge_path(params[:id])
    end
  end

  def new
    if !logged?
      redirect_to challenges_path
    end
  end

  def update
    if !logged?
      redirect_to challenge_path(params[:id])
    end
    begin

      files = save_files

      @challenge = Challenge.find(params[:id])
      fill_challenge

      rem_files = []
      if !params[:rem_attachments].nil?
        params[:rem_attachments].each do |id, val|
          if val == "0"
            begin
              oldfile = Attachment.where("challenge_id = ? AND id = ?", @challenge.id, id.to_i).first
              oldfile.destroy unless oldfile.nil?
            rescue
            end
          end
        end
      end

      create_attachments files, @challenge.id

      flash[:notice] = "#{@challenge.name} was successfully updated."
      redirect_to challenges_path
    rescue Exception => e
      rollbackUpload files
      flash[:error] = "Error updating the challenge: #{e.message}"
      redirect_to challenges_path
    end
  end

  def create
    if !logged?
      flash[:error] = "You must be logged in order to insert new challenges"
      redirect_to challenges_path
    end
    begin

      files = save_files

      @challenge = Challenge.new()
      fill_challenge

      create_attachments files, @challenge.id

      @challenge.author.points += Challenge.pointsPerChallengeInsertion
      @challenge.author.save

      Participant.all.each do |p|
        if p.id != @challenge.author.id
          SystemMailer.new_challenge(p, challenge)
        end
      end
      flash[:notice] = "#{@challenge.name} was successfully created. +10 points :)"
      redirect_to challenges_path
    rescue Exception => e
      @challenge.destroy unless @challenge.nil?
      begin
        rollbackUpload files
        flash[:error] = "Error creating challenge: #{e.message}"
      rescue Exception => e1
        flash[:error] = "Error creating challenge: #{e.message}, #{e1.message}"
      end
      redirect_to new_challenge_path
    end
  end

  private

  def save_files
      files = []
      if !params[:attachments].nil?
        params[:attachments].each do |id, file|
          res = Attachment.save(id, file)
          files << res unless res.nil?
        end
      end
      return files
  end

  def fill_challenge
      @challenge.name = params[:challenge][:name]
      @challenge.text = params[:challenge][:text]
      @challenge.solution = params[:challenge][:solution]
      @challenge.author = current_participant
      @challenge.points = params[:challenge][:points]
      @challenge.category = params[:challenge][:category]
      @challenge.save!
  end

  def create_attachments files, id
      files.each do |f|
        next if f.nil?
        @attachment = Attachment.new()
        @attachment.challenge_id = id
        @attachment.file = f[:file]
        @attachment.name = f[:name]
        @attachment.save!
      end
  end

  def logged?
    return !current_participant.nil?
  end

  def rollbackUpload files
    error = ""
    files.each do |f|
      begin
        Attachment.remove(f[:name])
      rescue Exception => e
        error += e.message + " "
      end
    end
    raise Exception, error unless error == ""
  end

end
