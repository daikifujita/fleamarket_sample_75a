class Product < ApplicationRecord

  belongs_to :saler, class_name: "User", dependent: :destroy
  belongs_to :buyer, class_name: "User", dependent: :destroy
  belongs_to :category
  has_many :pictures, dependent: :destroy

  enum condition: { 新品、未使用: 0, 未使用に近い:1, 目立った傷や汚れなし: 2, やや傷や汚れあり: 3, 傷や汚れあり: 4 }

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

end
