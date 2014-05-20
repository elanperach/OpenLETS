class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject}"
    redirect_to root_url, :alert => exception.message
  end

  helper_method :filter_params, :set_filter_param, :current_economy, :current_member, 
                :member_signed_in?, :filter_params, :all_items, :all_wishes, :all_users, 
                :all_transactions, :all_wallets, :all_members, :all_categories

  def filter_params
    params["filter"] ||= {}
  end

  def current_economy
    @current_economy ||= Economy.find_by_domain("http://#{request.host_with_port}")
  end

  def current_ability
    if current_economy
      @current_ability ||= Ability.new(current_user, current_member, current_economy)
    else
      @current_ability ||= Ability.new(current_user)
    end
  end

  def current_member
    if current_user
      @member ||= (current_economy ? current_user.memberships.where(economy_id: current_economy.id).first : current_user)
    end
  end

  def member_signed_in?
    # current_member.blank?
    current_user.memberships.map(&:economy_id).include?(current_economy.id)
  end

  def filter_params
    params["filter"] ||= {}
  end

  def all_items
    @all_items ||= (current_economy ? current_economy.items : Item.all)
  end

  def all_wishes
    @all_wishes ||= (current_economy ? current_economy.wishes : Item.all)
  end

  def all_users
    @all_users ||= (current_economy ? current_economy.users : User.all)
  end

  def all_members
    @all_members ||= (current_economy ? current_economy.members : Member.all)
  end

  def all_wallets
    @all_wallets ||= (current_economy ? current_economy.wallets : Wallet.all)
  end

  def all_categories
    @all_categories ||= (current_economy ? current_economy.categories : Category.all)
  end

  def all_transactions
    @all_transactions ||= (current_economy ? current_economy.transactions : Transaction.all)
  end  

end