class Area < ApplicationRecord
	has_many :rooms, dependent: :destroy

	geocoded_by :address
	after_validation :geocode
end
