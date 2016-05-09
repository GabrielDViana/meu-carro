class UsersController < ApplicationController
  helper_method :confirm_payment
  def index
    @users = User.all
  end

  def show
    @user = User.find_by_token(params[:token])
  end

  def new
    @user = User.new
  end
# Metodo create irá pedir que o usuário confirme o email
  def create
    @user = User.new(user_params)
    # Caso o usuario seja salvo com os dados validos, um email sera enviado
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      flash[:error] = "Por favor confirme seu cadastro no email que enviamos"
      redirect_to login_url
    else
      flash[:error] = "Tente novamente! Ocorreu alguma falha no cadastro."
      render 'new'
    end
  end

  def update
    @user = User.find_by_token(params[:token])
    if @user.update(user_params)
      redirect_to @user
      flash[:success] = 'Perfil atualizado'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url
    flash[:success] = 'Conta removida com sucesso.'
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Bem vindo a Meu Caro!"
      redirect_to login_url
    else
      flash[:error] = "Desculpe, o usuário não existe"
      redirect_to login_url
    end
  end

  def confirm_payment
    @user = User.find_by_token(params[:token])
    @payment = PagSeguro::PaymentRequest.new

    # Você também pode fazer o request de pagamento usando credenciais
    # diferentes, como no exemplo abaixo

    @payment.reference = @user.token

    @payment.items << {
      id: @user.id,
      description: "Pagamento para registro no MeuCarro",
      amount: 19.90
    }

    response = @payment.register

    if response.errors.any?
      raise response.errors.join("\n")
    else
      redirect_to response.url
    end
  end

  private
    def set_user
      @user = User.find_by_token(params[:token])
    end

    def user_params
      params.require(:user).permit(:complete_name, :email,
          :password, :password_confirmation)
    end
end
