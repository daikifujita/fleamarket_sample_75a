## users_table
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false,|
|email|string|null: false, unique: true|
|password|string|null: false|
|first_name|string|null: false|
|last_name|string|null: false|
|first_name_kana|string|null: false|
|last_name_kana|string|null: false|
|birthday|date|null: false|
|is_deleted|boolean|null: false, default:false|
### Association
<!-- userが削除された場合は、以下を消す。 -->
- has_one : address, dependent: :destroy
- has_one : credit, dependent: :destroy
<!-- 以下、null制限が必要 -->
  has_many  :bought_products,                                         foreign_key: "buyer_id", class_name: "Product",  dependent: :restrict_with_error
  has_many  :saling_products, -> { where("buyer_id is NULL") },       foreign_key: "saler_id", class_name: "Product",  dependent: :restrict_with_error
  has_many  :sold_products,   -> { where("buyer_id is not NULL") },   foreign_key: "saler_id", class_name: "Product",  dependent: :restrict_with_error
<!-- userが削除されても、以下は消さない。 -->
- has_many : purchases, dependent: :restrict_with_error
- has_many : comments, dependent: :restrict_with_error
- has_many : favorites, dependent: :restrict_with_error
## addresses_table
|Column|Type|Options|
|------|----|-------|
|postcode|integer|null: false|
|prefecture_id(acitve_hash)|integer|null: false|
|city|string|null: false|
|street|text|null: false|
|building|text||
|phone_number|string||
|user|references|null: false, foreign_key: true|
### Association
- belongs_to :user
## creditcards_table
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foreign_key: true|
|customer_id|string|null: false|
|card_id|string|null: false|
### Association
- belongs_to :user
## products_table
|Column|Type|Options|
|------|----|-------|
|price|integer|null: false|
|name|string|index: true,null: false|
|explanation|text|null: false|
|brand|string||
|condition(enum)|integer|null: false|
|prefecture_id(acitve_hash)|integer|null: false|
|preparationdays|integer|null: false|
|is_shipping_buyer|boolean|null: false|
|saler_id|references||
|buyer_id|references||
|category|references|null: false, foreign_key: true|
|user|references|null: false, foreign_key: true|
### enum
enum condition: { 新品、未使用(unused): 0, 未使用に近い(near_unused):1, 目立った傷や汚れなし(no_noticeable_scratches_dirt): 2, やや傷や汚れあり(some_scratches_dirt): 3, 傷や汚れあり(scratches_dirt): 4}
### Association
- belongs_to :user
- belongs_to :saler, class_name: "User", optional: true, dependent: :destroy
- belongs_to :buyer, class_name: "User", optional: true, dependent: :destroy
- belongs_to :category
- belongs_to_active_hash :prefecture
<!-- productが削除された場合は、以下を消す。 -->
- has_many : pictures,  dependent: :destroy
- has_many : comments, dependent: :destroy
- has_many : favorites, dependent: :destroy
<!-- productが削除されても、以下は消さない。 -->
- has_many : purchases,  dependent: :restrict_with_error
- accepts_nested_attributes_for :pictures, allow_destroy: true
### What are user_id, saler_id and buyer_id?
- user_id : この商品の持ち主のユーザーID（user_idの人がその商品を未出品下書き保存中、出品中、売却済みのどれかであることを示す）
- saler_id : この商品を出品したユーザーID（saler_idの人がその商品を出品中、売却済みのどちらかであることを示す）
- buyer_id : この商品を購入したユーザーID（saler_idの人がその商品を売却済みである）
## pictures_table
|Column|Type|Options|
|------|----|-------|
|image|string|null: false|
|product|references|null: false, foreign_key: true|
### Association
- belongs_to :product
## categories_table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string|index: true|
### Association
- has_many : products, dependent: :destroy
- has_ancestry
## purchases_table
|Column|Type|Options|
|------|----|-------|
|product|references|null: false, foreign_key: true|
<!-- 閲覧者(購入者)のuser_id)-->
|user|references|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :product
## comments_table
|Column|Type|Options|
|------|----|-------|
|body|text|null: false|
|product|references|null: false, foreign_key: true|
<!-- 閲覧者のuser_id -->
|user|references|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :product
## favorites_table
|Column|Type|Options|
|------|----|-------|
|product|references|null: false, foreign_key: true|
<!-- 閲覧者のuser_id -->
|user|references|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :product