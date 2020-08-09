class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string      :name,              null: false
      t.integer     :price,             null: false
      t.text        :explanation,       null: false
      t.integer     :condition,         null: false
      t.integer     :prefecture_id,     null: false
      t.integer     :preparationdays,   null: false
      t.boolean     :is_shipping_buyer, null: false
      t.string      :brand
      t.references  :saler_id
      t.references  :buyer_id
      t.references  :user,              null: false, foreign_key: true
      t.references  :category,          null: false, foreign_key: true
      t.timestamps
    end

    add_index :products, :name
  end
end
