class UsersController < ApplicationController
  layout 'my_orders', only: [:orders, :line_items]
  before_action :set_user, only: %i[ show edit update destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_user

  # GET /users or /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.build_address
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html {
          redirect_to users_url,
                      notice: t(".created")
        }

        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html {
          redirect_to users_url,
                      notice: "User #{@user.name} was successfully updated."
        }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    notice = @user.destroy ? t(".success") : @user.errors[:base]

    respond_to do |format|
      format.html { redirect_to users_url, notice: notice }
      format.json { head :no_content }
    end
  end

  rescue_from "User::Error" do |exception|
    redirect_to users_url, notice: exception.message
  end

  def orders
    @user = User.find(session[:user_id])
    @orders = @user.orders
  end

  def line_items
    @user = User.find(session[:user_id])
    @line_items = @user.line_items.page(params[:page])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :email, address_attributes: [:city, :state, :country, :pincode, :_destroy])
  end

  def invalid_user
    logger.error t('users.errors.access_invalid_user', user_id: params[:user_id])
    redirect_to users_url, status: :not_found, notice: t('users.errors.invalid_user')
  end
end
