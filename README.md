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
- has_many :buyed_products, dependent: :restrict_with_error
- has_many :saling_products, dependent: :restrict_with_error
- has_many :sold_products, dependent: :restrict_with_error
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
<!-- 出品者のuser_id -->
|user|references|null: false, foreign_key: true|
### enum
enum condition: { 新品、未使用: 0, 未使用に近い:1, 目立った傷や汚れなし: 2, やや傷や汚れあり: 3, 傷や汚れあり: 4}
### Association
- belongs_to :saler, dependent: :destroy_all
- belongs_to :buyer, dependent: :destroy_all
- belongs_to :category
<!-- productが削除された場合は、以下を消す。 -->
- has_many : pictures,  dependent: :destroy_all
- has_many : comments, dependent: :destroy_all
- has_many : favorites, dependent: :destroy_all
<!-- productが削除されても、以下は消さない。 -->
- has_many : purchases,  dependent: :restrict_with_error
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
- has_many : products, dependent: :destroy_all
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