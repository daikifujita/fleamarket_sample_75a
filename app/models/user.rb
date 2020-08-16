class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :nickname, :first_name, :last_name, :first_name_kana, :last_name_kana,  :birthday, presence:true
  validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i} #同一メールアドレスを登録できないようにする。
  validates :is_deleted, inclusion: { in: [true, false] }

  has_one   :address,           dependent: :destroy
  has_many  :bought_products,                                         foreign_key: "buyer_id", class_name: "Product",  dependent: :restrict_with_error
  has_many  :saling_products, -> { where("buyer_id is NULL") },       foreign_key: "saler_id", class_name: "Product",  dependent: :restrict_with_error
  has_many  :sold_products,   -> { where("buyer_id is not NULL") },   foreign_key: "saler_id", class_name: "Product",  dependent: :restrict_with_error
  

end


