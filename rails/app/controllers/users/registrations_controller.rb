skip_before_filter :verify_authenticity_token, :only => :create

def create
  @user = User.new(user_params)

  if @user.save
    sign_in @user
    json = ::UserSerializer.new(current_user).as_json
    json[:user].merge(token: current_user.authentication_token)
    render json: json, status: :created
  else
    render json: {errors: @user.errors.to_json}, status: :unauthorized
  end
end
  private
  def user_params
    params.require(:user).permit(:email, :password)
  end