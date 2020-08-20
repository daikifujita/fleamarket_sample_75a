class PurchaseController < ApplicationController
  def index
     #商品/ユーザー/クレジットカードの変数設定
    @user = current_user
    @card = Card.where(user_id: current_user.id).first
    @address = Address.where(user_id: current_user.id).first
    @product = Product.find(params[:id])
    #Payjpの 秘密鍵を取得
    Payjp.api_key =  ENV["PAYJP_PRIVATE_KEY"]
    #Payjpから顧客情報を取得し、表示
    customer = Payjp::Customer.retrieve(@card.customer_id)
    @card_information = customer.cards.retrieve(@card.card_id)
    @card_brand = @card_information.brand 
    case @card_brand
    when "Visa"
      @card_src = "visa.png"
    when "JCB"
      @card_src = "jcb.png"
    when "MasterCard"
      @card_src = "master-card.png"
    when "American Express"
      @card_src = "american_express.png"
    when "Diners Club"
      @card_src = "dinersclub.png"
    when "Discover"
      @card_src = "discover.png"
    end
  end
  def buy
    #クレジットカードと製品の変数を設定
    @card = Card.where(user_id: current_user.id).first
    @product = Product.find(params[:id])
    #Payjpの秘密鍵を取得
    Payjp.api_key= ENV["PAYJP_PRIVATE_KEY"]
    #payjp経由で支払いを実行
    charge = Payjp::Charge.create(
      amount: @product.price,
      customer: Payjp::Customer.retrieve(@card.customer_id),
      currency: 'jpy'
    )
    #製品のbuyer_idを付与
    @product_buyer= Product.find(params[:id])
    @product_buyer.update( buyer_id: current_user.id)
    redirect_to purchased_product_path
  end
end