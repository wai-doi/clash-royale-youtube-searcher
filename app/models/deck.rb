class Deck < ApplicationRecord
  has_many :matches, dependent: :destroy
  has_many :stats_royale_videos, through: :matches
  has_many :buildings, dependent: :destroy
  has_many :cards, through: :buildings

  validates :sorted_card_names, presence: true, uniqueness: true
end
