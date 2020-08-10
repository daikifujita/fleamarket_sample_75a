class ProductsController < ApplicationController
  def index
    @products = Product.includes(:pictures).order('created_at DESC')
  end

  def new
    if user_signed_in?
      @product = Product.new
      @product.pictures.new
      end
    else
      redirect_to root_path
    end
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
