class GraphsController < ApplicationController

  def index
    @products = Product.where(saler_id: current_user).where.not(buyer_id: nil)

    today = Date.today
    @sold_6days_ago_products = @products.where(tradeday: today.ago(6.days))	
    @sold_5days_ago_products = @products.where(tradeday: today.ago(5.days))	
    @sold_4days_ago_products = @products.where(tradeday: today.ago(4.days))	
    @sold_3days_ago_products = @products.where(tradeday: today.ago(3.days))	    
    @sold_2days_ago_products = @products.where(tradeday: today.ago(2.days))	
    @sold_1days_ago_products = @products.where(tradeday: today.ago(1.days))	
    @sold_today_products = @products.where(tradeday: today)
    
    @total_amounts = []

    @total_amounts << @sold_6days_ago_products.all.sum(:price)
    @total_amounts << @sold_5days_ago_products.all.sum(:price)
    @total_amounts << @sold_4days_ago_products.all.sum(:price)
    @total_amounts << @sold_3days_ago_products.all.sum(:price)
    @total_amounts << @sold_2days_ago_products.all.sum(:price)
    @total_amounts << @sold_1days_ago_products.all.sum(:price)
    @total_amounts << @sold_today_products.all.sum(:price)

    gon.total_amounts = @total_amounts

  end
  
end
