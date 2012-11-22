class Challenge < ActiveRecord::Base

  cattr_reader :pointsPerChallengeInsertion
  @@pointsPerChallengeInsertion = 10

  has_many :solutions, :dependent => :destroy
  has_many :solvers, :through => :solutions, :source => :participant
  belongs_to :author, :class_name => "Participant"
  has_many :attachments, :dependent => :destroy

  validates :points, :presence => { :message => "is mandatory" }, :numericality => {:only_integer => true, :greater_than => 0, :message => "must be a number grather than 0" }
  validates :name, :uniqueness => { :message => "already exists!" }, :presence => { :message => "can't be blank"}
  validates :category, :solution, :text, :presence => {:message => "can't be blank"}

end
