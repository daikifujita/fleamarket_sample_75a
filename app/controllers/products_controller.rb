class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :destroy, :update]

  def index
    @products = Product.includes(:pictures).order('created_at DESC')
  end

  def new

    if user_signed_in?
      @product = Product.new
      @product.pictures.new
      @category_parent_array =  Category.where(ancestry: nil) do |parent|
        @category_parent_array << @category_parent_array =  Category.where(ancestry: nil)
      end
    else
      redirect_to root_path
    end

  end

  def create
    @product = Product.new(product_params)
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
      @category_parent_array <<  @category_parent_array =  Category.where(ancestry: nil)
      render :index
    end
  end

  def show

  end

  def edit

    @category_parent_array = []
    # categoriesテーブルから親カテゴリーのみを抽出、配列に格納
    @category_parent_array = Category.where(ancestry: nil).pluck(:name)


    # itemに紐づいていいる孫カテゴリーの親である子カテゴリが属している子カテゴリーの一覧を配列で取得
    @category_child_array = @product.category.parent.parent.children

    # itemに紐づいていいる孫カテゴリーが属している孫カテゴリーの一覧を配列で取得
    @category_grandchild_array = @product.category.parent.children


  end

  def update

    if @product.update(product_params)
      redirect_to products_path , notice: 'グループを更新しました'
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      redirect_to products_path
    else
      render :index
    end
  end

  def get_category_children
    @category_children = Category.find_by(id: params[:parent_name]).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end
  
  private

    def product_params
      params.require(:product).permit(:price, :name, :explanation, :brand, :condition, :preparationdays, :prefecture_id, :is_shipping_buyer, :category_id, pictures_attributes: [:image, :destroy, :id]).merge(user_id: current_user.id, saler_id: current_user.id)
    end



  def image_params
    params.require(:pictures).permit({images: []})
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
