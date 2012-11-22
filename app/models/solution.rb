class Solution < ActiveRecord::Base
  belongs_to :challenge
  belongs_to :participant
end
