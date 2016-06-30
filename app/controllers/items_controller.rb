class ItemsController < ApplicationController


  def index
  	@categories = Category.all
  	@recommended = Item.all.limit(3)
  	@items = Item.all.order("id desc").limit(6)
  end

  def create

  	@products = Item.new(item_params)
  	if @products.save
  		redirect_to "/users/#{current_user.id}"
  	else
  		flash[:errors] = @products.errors.full_messages
  		redirect_to "/users/#{current_user.id}"
  	end
  end

  def update
  	@product = Item.find(params[:id])
  	@product.update(item_params)
  	if @product.save
  		redirect_to "/users/#{current_user.id}"
  	else
  		flash[:errors] = @product.errors.full_messages
  		redirect_to "/users/#{current_user.id}"
  	end
  end


  def destroy
  	@product = Item.find(params[:id])
  	@product.destroy
  	redirect_to "/users/#{current_user.id}"
  end


  def add_to_cart
    Cart.create(item:Item.find(params[:item_id]), days:params[:days], start:params[:start])
    redirect_to "/items"
  end


  private

  def item_params
    @category = Category.find_by(name: params[:category])
  	params.require(:item).permit(:name, :price, :description, :user_id,  :image).merge(category_id: @category.id)
  end

end
