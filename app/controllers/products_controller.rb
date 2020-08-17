class ProductsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @products = Product.includes(:pictures).order('created_at DESC')
  end

  def new
    # @user = User.find(params[:user_id])
    # @product = Product.new
    # @product.pictures.build
    # @category_parent_array =  Category.where(ancestry: nil) do |parent|
    #   @category_parent_array << parent
    # end

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
    @product = Product.find(params[:id])

  end

  def edit
    @product = Product.find(params[:id])
    grandchild_category = @product.category
    child_category = grandchild_category.parent


    @category_parent_array = []
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end

    @category_children_array = []
    Category.where(ancestry: child_category.ancestry).each do |children|
      @category_children_array << children
    end

    @category_grandchildren_array = []
    Category.where(ancestry: grandchild_category.ancestry).each do |grandchildren|
      @category_grandchildren_array << grandchildren
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      redirect_to products_path , notice: 'グループを更新しました'
    else
      render :edit
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    redirect_to products_path
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
