class AddTokensToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirm_token, :string
    add_column :users, :token, :string
    add_column :users, :email_confirmed, :boolean
  end
end
