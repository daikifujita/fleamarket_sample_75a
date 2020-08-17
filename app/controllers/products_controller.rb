class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.includes(:pictures).order('created_at DESC')
  end

  def new
    @user = User.find(params[:user_id])
    @product = Product.new
    @product.pictures.build
    @category_parent_array =  Category.where(ancestry: nil) do |parent|
      @category_parent_array << parent
    end
  end

  def create
    @product = Product.new(create_params)
    if @product.save
      # 関連するpicturesを作成
      image_params[:images].each do |image|
        if image !=""
          @product.pictures.create(image: image)
        else
          next
        end
      end
      # redirect_to request.referrer, notice: 'succeded sending'
      respond_to do |format|
        format.json
      end
    else
      @category_parent_array =  Category.where(ancestry: nil) do |parent|
        @category_parent_array << parent
      end
      render :index
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
    @category_children = Category.find_by(id: params[:parent_name]).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end
  
  private

  def create_params
    product_params = params.require(:product).permit(
      :price,
      :name,
      :explanation,
      :brand,
      :condition,
      :preparationdays,
      :prefecture_id,
      :category_id,
      :is_shipping_buyer
    ).merge(user_id: params[:user_id], saler_id: params[:user_id])
    return product_params
  end

  def image_params
    params.require(:pictures).permit({images: []})
  end

end
