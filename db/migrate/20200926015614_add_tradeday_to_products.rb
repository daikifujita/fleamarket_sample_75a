class AddTradedayToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :tradeday, :date
  end
end
