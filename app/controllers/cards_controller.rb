class CardsController < ApplicationController
  require "payjp"
  before_action :set_card, only: [:new, :destroy]
  before_action :set_payjp_secretkey, except: :new

  def index #Cardのデータpayjpに送り情報を取り出します]
    
    @card = Card.where(user_id: current_user.id).first
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
    end
  end
  
  def new
    redirect_to action: "index" if @card.present?
  end

  def create #payjpとCardのデータベース作成を実施します。
    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(
      email: current_user.email, 
      card: params['payjp-token'],
      metadata: {user_id: current_user.id}
      ) 
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to action: "index"
      else
        redirect_to action: "new"
      end
    end
  end
  def destroy #PayjpとCardデータベースを削除します
    
    if @card.present?
      customer = Payjp::Customer.retrieve(@card.customer_id)
      customer.delete
      @card.delete
    end
      redirect_to action: "index"
  end

  private
  def set_card 
    @card = Card.where(user_id: current_user.id).first
  end

  #Payjpの 秘密鍵を取得  
  def set_payjp_secretkey
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_SECRET_KEY]
  end
end
