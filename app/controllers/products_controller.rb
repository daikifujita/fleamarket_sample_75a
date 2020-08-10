class ProductsController < ApplicationController
  def index
    @products = Product.includes(:pictures).order('created_at DESC')
  end

  def new

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
