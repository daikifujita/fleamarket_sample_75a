class Product < ApplicationRecord

  validates :condition, :preparationdays, :prefecture_id, :category_id, presence: true  
  validates :name,                presence: true, length: { maximum: 40 }
  validates :explanation,         presence: true, length: { maximum: 1000 }
  validates :price,               numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than: 10000000 }
  validates :is_shipping_buyer,   inclusion: { in: [ true, false] }
  
  # validates_associated :pictures
  # validates :pictures, presence: true

  belongs_to :user
  belongs_to :saler, class_name: "User", optional: true, dependent: :destroy
  belongs_to :buyer, class_name: "User", optional: true, dependent: :destroy
  belongs_to :category
  has_many :pictures, dependent: :destroy

  enum condition: { "新品、未使用": 0, "未使用に近い": 1, "目立った傷や汚れなし": 2, "やや傷や汚れあり": 3, "傷や汚れあり": 4 }
  enum preparationdays: { "1~2日で発送": 0, "2~3日で発送": 1, "4~7日で発送": 2}

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

end
