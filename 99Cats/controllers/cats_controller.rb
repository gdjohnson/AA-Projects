class CatsController < ApplicationController

  def index
    @cats = Cat.all 

    render :index
  end

  def show
    # debugger
    #find => error, if not found in db
    #find_by => nil, if not found in db
    @cat = Cat.find(params[:id])
    
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new

    if @cat.save
      redirect_to cat_url(@cat)
    else
      render json: @cat.errors.full_messages, status: 422
    end
  end

end