class Classroom < ApplicationRecord
  REGEX = /\A([0-1]?[0-9]|2[0-3]):[0-5][0-9]\z/
  belongs_to :leader_marriage, class_name: "Marriage"
  belongs_to :co_leader_marriage, class_name: "Marriage"
  belongs_to :address, optional: true

  has_many :classroom_students
  has_many :student_marriages, through: :classroom_students, source: :marriage


  validates :class_time, format: { with: REGEX, message: "O formato deve ser HH:MM" }
  validates :weekday, inclusion: { in: %w[sunday monday tuesday wednesday thursday friday saturday] }
  validate :should_have_a_leader_and_co_leader
  validate :student_limit

  before_create :set_semester

  scope :active, -> { where(active: true) }

  private

  def set_semester
    year = Date.today.year
    semester = Date.today.month < 7 ? 1 : 2
    self.semester = "#{year}.#{semester}"
  end

  def should_have_a_leader_and_co_leader
    errors.add(:leader_marriage, "deve ser um casal de lider") unless leader_marriage.husband.role == "leader"
    errors.add(:co_leader_marriage, "deve ser um casal de co lider") unless co_leader_marriage.husband.role == "co_leader"
  end

  def student_limit
    return unless classroom_students.count > 5
    errors.add(:base, "Classroom cannot have more than 5 student couples")
  end
end
