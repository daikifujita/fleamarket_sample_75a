class Product < ApplicationRecord

  belongs_to :saler, class_name: "User", dependent: :destroy
  belongs_to :buyer, class_name: "User", dependent: :destroy
  belongs_to :category
  has_many :pictures, dependent: :destroy

  enum condition: { unused: 0, near_unused: 1, no_noticeable_scratches_dirt: 2, some_scratches_dirt: 3, scratches_dirt: 4 }

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

end
