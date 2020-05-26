class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end


  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    #beforeフィルター
    #ログイン済ユーザーか確認
    def logged_in_user
      unless logged_in?
       flash[:danger] = "ログインしてください。"
       redirect_to login_url
      end
    end
    
    #アクセスユーザーが現在ログインしているユーザーか確認
    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        flash[:danger] = "このユーザーは編集できません。"
        redirect_to user_url(@user)
      end
    end
end
