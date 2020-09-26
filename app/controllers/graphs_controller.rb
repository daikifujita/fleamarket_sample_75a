class GraphsController < ApplicationController

  def index
    @products = Product.where(saler_id: current_user).where.not(buyer_id: nil)

    today = Date.today
    @sold_2days_ago_products = @products.where(tradeday: today.ago(2.days))	
    @sold_1days_ago_products = @products.where(tradeday: today.ago(1.days))	
    @sold_today_products = @products.where(tradeday: today)
    
    @total_amount = []
    @total_amount << @sold_2days_ago_products.all.sum(:price)

  end
  
end
