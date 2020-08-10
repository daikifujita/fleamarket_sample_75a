class Product < ApplicationRecord

  belongs_to :user
  belongs_to :saler, class_name: "User", optional: true, dependent: :destroy
  belongs_to :buyer, class_name: "User", optional: true, dependent: :destroy
  belongs_to :category
  has_many :pictures
  accepts_nested_attributes_for :pictures, allow_destroy: true

  enum condition: { unused: 0, near_unused: 1, no_noticeable_scratches_dirt: 2, some_scratches_dirt: 3, scratches_dirt: 4 }

end
