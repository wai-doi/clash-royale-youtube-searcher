class Card < ApplicationRecord
  has_many :buildings
  has_many :decks, through: :buildings

  validates :name, presence: true, uniqueness: true
end
