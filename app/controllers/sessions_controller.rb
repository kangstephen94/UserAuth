class SessionsController < ApplicationController
  before_action :require_log_out, only: [:new]

  def new
    @user = User.new
    render :new
  end

  def create #creating a session
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    if @user
      login!(@user)
      redirect_to cats_url
    else
      flash[:errors] = ['Invalid Username or Password']
      redirect_to new_session_url
    end
  end

  def destroy
    logout
    redirect_to new_session_url
  end
end
