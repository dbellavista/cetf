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
    create! do |partecipant|
      partecipant.provider = auth["provider"]
      partecipant.uid = auth["uid"]
      partecipant.name = auth["info"]["name"]
      partecipant.points = 0
    end
  end

end
