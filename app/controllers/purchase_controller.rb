class PurchaseController < ApplicationController
  
  require "payjp"
  before_action :authenticate_user!
  before_action :set_card 
  before_action :set_product   #クレジットカードと製品の変数を設定
  before_action :set_payjp_secretkey

  def index
    
    @address = Address.where(user_id: current_user.id).first
    #Payjpから顧客情報を取得し、表示
    if @card.present?
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
    
    else 
    
    end  
  end

  def buy
    #payjp経由で支払いを実行
    charge = Payjp::Charge.create(
      amount: @product.price,
      customer: Payjp::Customer.retrieve(@card.customer_id),
      currency: 'jpy'
    )
    #製品のbuyer_idを付与
    @product_buyer= Product.find(params[:id])
    @product_buyer.update( buyer_id: current_user.id)
    redirect_to product_path
  end

  private 
  def set_card
    @card = Card.where(user_id: current_user.id).first
  end

  def set_product
    @product = Product.find(params[:id])
  end

  #Payjpの 秘密鍵を取得
  def set_payjp_secretkey
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_SECRET_KEY]
  end
end