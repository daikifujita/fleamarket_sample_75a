class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  
  validates :nickname, :first_name, :last_name, :first_name_kana, :last_name_kana,  :birthday, presence:true
  validates :first_name_kana, :last_name_kana, format: {with: /\A[ァ-ヶー－]+\z/}
  validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i} #同一メールアドレスを登録できないようにする。
  validates :is_deleted, inclusion: { in: [true, false] }

  has_one   :address,           dependent: :destroy
  has_one   :card,              dependent: :destroy
  has_many  :bought_products,                                         foreign_key: "buyer_id", class_name: "Product",  dependent: :restrict_with_error
  has_many  :saling_products, -> { where("buyer_id is NULL") },       foreign_key: "saler_id", class_name: "Product",  dependent: :restrict_with_error
  has_many  :sold_products,   -> { where("buyer_id is not NULL") },   foreign_key: "saler_id", class_name: "Product",  dependent: :restrict_with_error
  has_many :sns_credentials

  include JpPrefecture
  jp_prefecture :prefecture_id
  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_id).try(:name)
  end
    
  def prefecture_name=(prefecture_name)
    self.prefecture_id = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
  def self.from_omniauth(auth)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    # sns認証したことがあればアソシエーションで取得
    # 無ければemailでユーザー検索して取得orビルド(保存はしない)
    user = sns.user || User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
        email: auth.info.email
    )
    # userが登録済みの場合はそのままログインの処理へ行くので、ここでsnsのuser_idを更新しておく
    if user.persisted?
      sns.user = user
      sns.save
    end
    { user: user, sns: sns }
  end
end


