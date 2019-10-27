class ReviewsController < ApplicationController

  def new
    @product = Product.find_by(id: params[:product_id])   
    if session[:user_id] != nil 
      if @product.merchant_id == Merchant.find_by(id: session[:user_id]).id
        flash[:failure] = "A problem occurred: You cannot review your own product."
        redirect_to product_path(id: @product.id) 
      else 
        @review = Review.new()
      end    
    else 
      @review = Review.new()
    end
  end

  def create
   @review = Review.new(review_params)
    if @review.save
      flash[:success] = "Review was succesfully posted"
      redirect_to product_path(id: @review.product_id)
      return
    else 
      flash[:failure] = "A problem occurred"
      render :new, status: :bad_request 
      return
    end  
  end
  
  private
  
  def review_params
    return params.require(:review).permit(:comment, :rating, :reviewer, :product_id, :date)
  end

end

