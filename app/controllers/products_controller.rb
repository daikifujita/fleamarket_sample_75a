class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]
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
      @category_parent_array << @category_parent_array = Category.where(ancestry: nil)
      render :index
    end
  end

  def show
    @category_parent_array = Category.where(ancestry: nil) do |parent|
      @category_parent_array << @category_parent_array = Category.where(ancestry: nil)
    end

    @category_child_array = @product.category.parent.parent.children
    @category_grandchild_array = @product.category.parent.children
  end

  def edit
    @product = Product.find(params[:id])
    @pictures = Picture.where(product_id: params[:id])
    @category_parent_array =  Category.where(ancestry: nil) do |parent|
      @category_parent_array << @category_parent_array =  Category.where(ancestry: nil)
    end

    # @category_parent_array = Category.where(ancestry: nil).pluck(:name, :id)
    @category_child_array = @product.category.parent.parent.children
    @category_grandchild_array = @product.category.parent.children
    respond_to do |format|
      format.html
      format.json
    end
  end

  def update
    @product = Product.find(params[:id])
    @pictures = Picture.where(product_id: params[:id])
    array_length = @pictures.length

    if @product.update(product_params)
      # 関連するpicturesを作成
      image_params[:images].each_with_index do |image, i|
        # DBに既に保存されている部分についての処理
        if i < array_length
          # 対象が削除された場合
          if image == ""
            @product.pictures[i].destroy
          # 対象が存在する場合
          elsif image == "exist"
            next
          # 対象が変更された場合
          else
            @product.pictures[i].update(image: image)
          end
        # DBには保存されていない部分についての処理
        else
          if image != ""
            @product.pictures.create(image: image)
          else
            next
          end
        end
      end
      respond_to do |format|
        format.json
      end
    else
      render :edit,  id: current_user.id
    end
    
  end

  def destroy
    @product = Product.find(params[:id])
    @products = Product.includes(:pictures).order('created_at DESC')
    if @product.destroy
      redirect_to products_path
    else
      # render :index
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
