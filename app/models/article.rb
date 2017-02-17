class Article < ApplicationRecord
  acts_as_paranoid
  belongs_to :category
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags
  has_one :access
  validates :title,:category_id,:content, presence: true

  class << self
    def get_conditions params
      search = ['1 = 1 ']
      arr = [[]]
      if params[:search].present?
        search << ' articles.title like ? '
        arr << "%#{params[:search]}%"
      end
      if params[:category].present?
        search << ' articles.category_id = ? '
        arr << params[:category]
      end
      arr[0] = search.join 'and'
      arr.flatten
    end

  end

end
