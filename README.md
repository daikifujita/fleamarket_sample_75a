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
- has_one : address
- has_one : credit
- has_many : products
- has_many : purchases
- has_many : comments
- has_many : favorites

## addresses_table
|Column|Type|Options|
|------|----|-------|
|address_first_name|string|null: false|
|address_last_name|string|null: false|
|address_first_name_kana|string|null: false|
|address_last_name_kana|string|null: false|
|postcode|integer|null: false|
|prefecture|string|null: false|
|city|string|null: false|
|street|text|null: false|
|building|text||
|phone_number|integer||
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user

## credit_table
|Column|Type|Options|
|------|----|-------|
|card_name|string|null: false|
|card_number|integer|null: false|
|expire_month|integer|null: false|
|expire_year|integer|null: false|
|security_code|integer|null: false|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user

## products_table
|Column|Type|Options|
|------|----|-------|
|image|string|index: true, null: false|
|price|integer|null: false|
|name|string|null: false|
|explanation|text|null: false|
|brand|string||
|condition|string|null: false|
|area|string|null: false|
|preparationdays|integer|null: false|
|payer_flg|integer|null: false|
|category_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :category
- belongs_to :user
- has_many : pictures
- has_many : purchases
- has_many : comments
- has_many : favorites

## pictures_table
|Column|Type|Options|
|------|----|-------|
|image|string||
|product_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :product

## categories_table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string|index: true,null: false|

### Association
- has_many : products
- has_ancestry

## purchases_table
|Column|Type|Options|
|------|----|-------|
|number|string|null: false|
|product_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :product

## comments_table
|Column|Type|Options|
|------|----|-------|
|body|text|null: false|
|product_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :product

## favorites_table
|Column|Type|Options|
|------|----|-------|
|product_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :product