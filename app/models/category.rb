class Category < ApplicationRecord
  acts_as_paranoid
  has_many :articles
  validates :name,presence: true

end
