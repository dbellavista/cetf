class Participant < ActiveRecord::Base

  has_many :challenges, :foreign_key => :author_id
  has_many :solutions, :dependent => :destroy
  has_many :solved_challenges, :through => :solutions, :source => :challenge

  validates :uid, :uniqueness => {:scope => :provider, :message => "already registered!"}

  def self.names_ids
    participants = []
    Participant.select('id, name').each do |a|
      participants << [a.name, a.id]
    end
    return participants
  end

  def self.create_with_omniauth(auth)
    create! do |participant|
      participant.provider = auth["provider"]
      participant.uid = auth["uid"]
      participant.name = auth["info"]["name"]
      # TODO: check oauth field
      participant.email = auth["info"]["email"]
      participant.policy_new_challenge = true
      participant.policy_challenge_solved = true
      participant.points = 0
    end
  end

end
