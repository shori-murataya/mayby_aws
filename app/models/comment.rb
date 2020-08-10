class Comment < ApplicationRecord
  MAXIMUM_LENGTH_CONTENT = 140
  PER_COMMENT_AT_SHOW = 5
  validates :content, { presence: true, length: { maximum:MAXIMUM_LENGTH_CONTENT } }
  belongs_to :user
  belongs_to :post

  #must_be_ordered
end
