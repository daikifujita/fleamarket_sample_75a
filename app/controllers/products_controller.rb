class ProductsController < ApplicationController
  def index
    @products = Product.includes(:pictures).order('created_at DESC')
  end

  def new
    if user_signed_in?
      @product = Product.new
      @product.pictures.new
      @category_parent_array =  Category.where(ancestry: nil) do |parent|
        @category_parent_array << parent
      end
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

  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.find_by(id: params[:parent_name]).children
  end

  # 子カテゴリーが選択された後に動くアクション
  def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  
  private

  def product_params
    params.require(:product).permit(:price, :name, :explanation, :brand, :condition, :preparationdays, :category_id, :is_shipping_buyer, pictures_attributes: [:image, :destroy, :id]).merge(user_id: current_user.id)
  end

end
