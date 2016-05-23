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

  def assign
    @user = User.find_by_token(params[:token])
    @params = PaymentRequest.new
    pagseguro_session = PagSeguro::Session.new
    @pagseguro_session_id = pagseguro_session.create.id
    payment = PagSeguro::Payment.new(notification_url: 'http://localhost:3000/', payment_method: 'boleto', reference: '1')
    items = [PagSeguro::Item.new(id: 1, description: 'Assinatura', amount: 89.90, quantity: 1)]
    payment.items = items
    @sender = PagSeguro::Sender.new
    @sender.phone = PagSeguro::Phone.new(@params.area_code, @params.phone)
    @sender.document = PagSeguro::Document.new(@params.document)
    payment.sender = @sender
    @address = PagSeguro::Address.new
    shipping = PagSeguro::Shipping.new
    shipping.address = @address
    payment.shipping = shipping
    @credit_card = PagSeguro::CreditCard.new(@params.token)
    @credit_card.installment = PagSeguro::Installment.new(1, 1)
    @credit_card.holder = PagSeguro::Holder.new(@params.name, @params.birthdate)
    @credit_card.holder.document = PagSeguro::Document.new(@params.document_card)
    @credit_card.holder.phone = @sender.phone
    @credit_card.billing_address = @address
    payment.credit_card = @credit_card
    # @transaction = payment.transaction
    # if @transaction.errors.any?
    #   raise @transaction.errors.join("\n")
    # else
    #   @transaction.payment_link
    # end
  end

  def confirm_payment
    @user = User.find_by_token(params[:token])
    pagseguro_session = PagSeguro::Session.new
    @pagseguro_session_id = pagseguro_session.create.id
    payment = PagSeguro::Payment.new(notification_url: 'http://localhost:3000/', payment_method: 'boleto', reference: '1')
    items = [PagSeguro::Item.new(id: 1, description: 'Ticket 1', amount: 2.00, quantity: 1)]
    payment.items = items
    phone = PagSeguro::Phone.new('11', '999999999')
    document = PagSeguro::Document.new('04315078131')
    sender = PagSeguro::Sender.new(email: 'c34681120997911386961@sandbox.pagseguro.com.br', name: 'Gabriel Dias Viana', hash_id: '149b0727f23385380256a693a0148d91b50b56d9f784ad7322ff321e8014624f' )
    sender.phone = phone
    sender.document = document
    payment.sender = sender


    #### Adicionando endereço do comprador ou endereço de cobrança para cartão de crédito

    address = PagSeguro::Address.new(postal_code: '01318002', street: 'AV BRIGADEIRO LUIS ANTONIO', number: '1892', complement: '112', district: 'Bela Vista', city: 'São Paulo', state: 'SP')
    shipping = PagSeguro::Shipping.new
    shipping.address = address
    payment.shipping = shipping
    credit_card = PagSeguro::CreditCard.new('4111111111111111')
    credit_card.installment = PagSeguro::Installment.new(1, 1)
    creditcard_birthday =Date.new(2016, 1, 1)
    credit_card.holder = PagSeguro::Holder.new('Gabriel Dias Viana', creditcard_birthday )
    document = PagSeguro::Document.new('04315078131')
    credit_card.holder.document = document
    phone = PagSeguro::Phone.new('11', '999999999')
    credit_card.holder.phone = phone
    credit_card.billing_address = address
    payment.credit_card = credit_card
    transaction = payment.transaction
    if transaction.errors.any?
      raise transaction.errors.join("\n")
    else
      transaction.payment_link
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
