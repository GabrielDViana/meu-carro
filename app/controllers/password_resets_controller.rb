class PasswordResetsController < ApplicationController
    def new
    end

    def create
        user = User.find_by_email(params[:email])
        user.send_password_reset if user
        redirect_to login_url, :notice => "Foi enviado um email com a chave para redefinição de senha"
    end

    def edit
        @user = User.find_by_password_reset_token!(params[:id])
    end

    def update
        @user = User.find_by_password_reset_token!(params[:id])
        if @user.password_reset_sent_at < 3.hours.ago
            redirect_to password_resets_path, :alert => "Chave para redefinição de senha expirada! Favor solicitar nova chave!"
        elsif @user.update_attributes(params[:user])
            redirect_to login_url, :notice => "Senha atualizada!"
        else
            render :edit
        end
    end
end
