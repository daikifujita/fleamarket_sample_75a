class TopController < ApplicationController
  def index
    @product = Product.all
    @pictures = Picture.all
    @category_parent_array =  Category.where(ancestry: nil) do |parent|
      @category_parent_array << @category_parent_array =  Category.where(ancestry: nil)
    end
  end
end
