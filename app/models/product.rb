class Product < ApplicationRecord

  validates :condition, :preparationdays, :prefecture_id, :category_id, presence: true  
  validates :name,                presence: true, length: { maximum: 40 }
  validates :explanation,         presence: true, length: { maximum: 1000 }
  validates :price,               numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than: 10000000 }
  validates :is_shipping_buyer,   inclusion: { in: [true, false] }
  
  validates_associated :pictures
  validates :pictures, presence: true

  belongs_to :user
  belongs_to :saler, class_name: "User", optional: true, dependent: :destroy
  belongs_to :buyer, class_name: "User", optional: true, dependent: :destroy
  belongs_to :category
  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true

  enum condition: { unused: 0, near_unused: 1, no_noticeable_scratches_dirt: 2, some_scratches_dirt: 3, scratches_dirt: 4 }
  enum preparationdays: { days1_2: 0, days2_3: 1, days4_7: 2}

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

end
