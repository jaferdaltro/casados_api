class Address < ApplicationRecord
  has_one :marriage

  geocoded_by :location
  after_validation :geocode

  def location
    [ street, city, "Ceara", "Brazil" ].compact.join(", ")
  end
end
