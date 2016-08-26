class UsersController < ApplicationController

  before_action :authenticate_user!
  def index
    @users = User.all
    authorize @users
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user

    if @user.save
      redirect_to users_path, :flash => { :success => 'El Usuario ha sido creado correctamente.' }
      #redirect_to @user, :flash => { :success => 'User was successfully created.' }
    else
      render :action => 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    authorize @user

    if @user.update_attributes(user_params)
      sign_in(@user, :bypass => true) if @user == current_user
      redirect_to users_path, :flash => { :success => 'el Usuario ha sido actualizado correctamente.' }
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    redirect_to users_path, :flash => { :success => 'El Usuario fue borrado correctamente.' }
  end

  private
    def user_params
      params.require(:user).permit(:nombre, :apellido, :email, :password, :password_confirmation, :role)
    end
end