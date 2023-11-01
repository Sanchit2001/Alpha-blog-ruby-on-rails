class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, only: [:edit, :update, :destroy]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "Welcome to Alpha blog #{@user.username}, signup successful"
            redirect_to articles_path
        else
            logger.debug "Throwing Error Messages to Screen User"
            flash[:alert] = "Invalid Username, Email or Password or Fields Missing Try again"
            redirect_to :signup
        end
    end

    def edit
       
    end

    def update
        
        if @user.update(user_params)
            flash[:notice] = "Information is updated successfully"
            redirect_to @user
        end
    end

    def show
       
    end

    def index
        @users = User.all
    end

    def destroy
        @user.destroy
        session[:user_id] = nil if @user == current_user

        flash[:notice] = "Account and all associated Articles deleted :("
        redirect_to root_path
    end

    private
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def require_same_user
        if current_user!= @user && !current_user.admin?
            flash[:alert] = "You cannot edit profile of other blogger"
            redirect_to @user
        end
    end

end