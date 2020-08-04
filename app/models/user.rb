class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :nickname, :first_name, :last_name, :first_name_kana, :last_name_kana,  :birthday, presence:true
  validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i} #同一メールアドレスを登録できないようにする。
  validates :is_deleted, inclusion: { in: [true, false] }

  has_one  :address,       dependent: :destroy

end


