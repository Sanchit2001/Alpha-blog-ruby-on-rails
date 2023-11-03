class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:show, :index]
    before_action :require_same_user, only: [:edit, :update, :destroy]

    def show
    end

    def index
        @articles = Article.paginate(page:params[:page],per_page:5)
    end

    def new
        @article = Article.new
    end

    def edit
    
    end

    def create
        @article  = Article.new(params.require(:article).permit(:title, :description, category_ids: []))
        @article.user = current_user
        logger.debug "Article should be valid: #{@article.valid?}"
        if @article.save
            flash[:notice] = "Article created successfully :)"
            logger.debug "New article: #{@article}"
            redirect_to article_path(@article)
        else
            logger.debug "Throwing Error Messages to Screen"
            if @article.errors.any?
                @article.errors.full_messages.each do |msg|
                    logger.debug msg
                end
            end
            flash[:alert] = "Description or Ttile cannot be empty!"
            render :new
        end    
    end
    
    def update
        logger.debug "Article should be valid: #{@article.valid?}"
        if @article.update(params.require(:article).permit(:title, :description, category_ids: []))
            flash[:notice] = "Article updated successfully"
            redirect_to @article
        else
            logger.debug "Throwing Error Messages to Screen"
            if @article.errors.any?
                @article.errors.full_messages.each do |msg|
                    logger.debug msg
                end
            end
            flash[:alert] = "Description or Ttile cannot be empty!"
            render :new
        end
    end

    def destroy
        @article.destroy
        redirect_to articles_path 
    end

    private
    def set_article
        @article = Article.find(params[:id])
    end
    def require_same_user
        if current_user != @article.user && !current_user.admin?
            flash[:alert] = "You cannot edit article of other blogger"
            redirect_to @article
        end
    end
end