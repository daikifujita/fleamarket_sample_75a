class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :postcode,           null: false
      t.integer :prefecture_id,     null: false
      t.string :city,               null: false
      t.text :street,               null: false
      t.text :building 
      t.string :phone_number,       null: false, unique:true
      t.references :user,           null: false, foreign_key: true
      t.timestamps
    end
  end
end
