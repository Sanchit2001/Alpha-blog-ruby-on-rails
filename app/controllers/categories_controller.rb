class CategoriesController < ApplicationController
    before_action :require_admin, except: [:show, :index]
    before_action :set_category, only: [:show]
    
    def new
        @category = Category.new
    end

    def create
        @category = Category.new(category_params)
        if @category.save
            flash[:notice] = "Category Created Successfully"
            redirect_to @category
        else
            render 'new'
        end
    end

    def index
        @categories = Category.all
    end
    
    def show
    end

    private
    def category_params
        params.require(:category).permit(:name)
    end

    def set_category
        @category = Category.find(params[:id])
    end

    def require_admin
        if !(logged_in? && current_user.admin?)
            flash[:alert] = "Only admin can access this route"
            redirect_to categories_path
        end
    end

end