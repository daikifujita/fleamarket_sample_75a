class ProductsController < ApplicationController
  def index
    @products = Product.includes(:pictures).order('created_at DESC')
  end

  def new
    if user_signed_in?
      @product = Product.new
      @product.pictures.new
    else
      redirect_to root_path
    end
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def product_params
    params.require(:product).permit(:price, :name, :explanation, :brand, :condition, :preparationdays, :category_id, :is_shipping_buyer, pictures_attributes: [:image, :destroy, :id]).merge(user_id: current_user.id)
  end

end
