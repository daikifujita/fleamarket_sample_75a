class Address < ApplicationRecord
  
  validates :postcode, :prefecture_id, :city, :street, :phone_number, presence:true
  validates :postcode, format: { with: /\A\d{3}\-?\d{4}\z/ }
  validates :phone_number, format: { with: /\A\d{10}$|^\d{11}\z/ }
  
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  belongs_to :user, optional: true
end
