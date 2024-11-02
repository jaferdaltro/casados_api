class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :account

  enum role: { coordenator: "coordenator", leader: "leader", student: "student" }
end
