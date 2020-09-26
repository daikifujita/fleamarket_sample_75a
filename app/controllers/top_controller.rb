class TopController < ApplicationController
  def index
    @products = Product.includes(:pictures).order('created_at DESC')
    @saling_products = Product.where(buyer_id: nil).includes(:pictures).order('created_at DESC')
    @category_parent_array =  Category.where(ancestry: nil)
  end
end