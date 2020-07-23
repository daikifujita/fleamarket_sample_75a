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
|birthday_date|string|null: false|
|birthday_month|string|null: false|
|birthday_year|string|null: false|

### Association

<!-- userが削除された場合は、以下を消す。 -->
- has_one : address, dependent: :destroy
- has_one : credit, dependent: :destroy
- has_many : products, dependent: :destroy_all
<!-- userが削除されても、以下は消さない。 -->
- has_many : purchases, dependent: :nullify
- has_many : comments, dependent: :nullify
- has_many : favorites, dependent: :nullify

## addresses_table
|Column|Type|Options|
|------|----|-------|
|first_name|string|null: false|
|last_name|string|null: false|
|first_name_kana|string|null: false|
|last_name_kana|string|null: false|
|postcode|integer|null: false|
|prefecture_id(acitve_hash)|integer|null: false|
|city|string|null: false|
|street|text|null: false|
|building|text||
|phone_number|integer||
|user|references|null: false, foreign_key: true|

### Association
- belongs_to :user

## creditcards_table
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foreign_key: true|
|customer_id|integer|null: false|
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
|condition|string|null: false|
|prefecture_id(acitve_hash)|integer|null: false|
|preparationdays|integer|null: false|
|is_shipping_buyer|boolean|null: false|
|category|references|null: false, foreign_key: true|
<!-- 出品者のuser_id -->
|user|references|null: false, foreign_key: true|

### enum
enum condition: { 新品、未使用: 0, 未使用に近い:1, 目立った傷や汚れなし: 2, やや傷や汚れあり: 3, 傷や汚れあり: 4}

### Association
- belongs_to :user
- belongs_to :category
<!-- productが削除された場合は、以下を消す。 -->
- has_many : pictures,  dependent: :destroy_all
- has_many : comments, dependent: :destroy_all
- has_many : favorites, dependent: :destroy_all
<!-- productが削除されても、以下は消さない。 -->
- has_many : purchases,  dependent: :nullify

## pictures_table
|Column|Type|Options|
|------|----|-------|
|image|string||
|product|references|null: false, foreign_key: true|

### Association
- belongs_to :product

## categories_table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string|index: true,null: false|

### Association
- has_many : products, dependent: :destroy_all
- has_ancestry

## purchases_table
|Column|Type|Options|
|------|----|-------|
|number|string|null: false|
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