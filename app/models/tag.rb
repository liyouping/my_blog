class Tag < ApplicationRecord
  acts_as_paranoid
  has_many :articles, through: :article_tags,dependent: :destroy
 # has_and_belongs_to_many :articles, join_table: :article_tags
  validates :name,presence: true

end
