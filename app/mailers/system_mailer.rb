class SystemMailer < ActionMailer::Base
  default from: "\"CeSeNA CeTF Team\" <cetf.not_reply@anesec.it>"

  def welcome(participant)
    @participant = participant
    url = "https://cesena.ing2.unibo.it:8080/"
    @login_url = url + login_path
    @profile_url = url + participant_path(@participant.id)
    @challenges_url = url + challenges_path
    if !participant.email.nil?
        mail(:to => participant.email, :subject => "Welcome to CeTF - The open CTF") do |format|
          format.text
        end
    end
  end

  def new_challenge(participant, challenge)
    @participant = participant
    @challenge = challenge
    url = "https://cesena.ing2.unibo.it:8080/"
    @challenge_url = url + challenge_path(@challenge.id)
    if !participant.email.nil? & participant.policy_new_challenge
        mail(:to => participant.email, :subject => "CeTF - a new challenge for you!") do |format|
          format.text
        end
    end
  end

  def challenge_solved(participant, challenge)
    @participant = participant
    @challenge = challenge
    url = "https://cesena.ing2.unibo.it:8080/"
    @challenge_url = url + challenge_path(@challenge.id)
    @challenges_url = url + challenges_path
    if !participant.email.nil? & @challenge.author.policy_challenge_solved
        mail(:to => @challenge.author.email, :subject => "CeTF - your challenge has been solved!") do |format|
          format.text
        end
    end
  end

end
