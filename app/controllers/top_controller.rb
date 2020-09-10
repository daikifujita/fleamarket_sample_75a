class TopController < ApplicationController
  def index
    @products = Product.all.includes(:pictures)
    @category_parent_array =  Category.where(ancestry: nil)
  end
end