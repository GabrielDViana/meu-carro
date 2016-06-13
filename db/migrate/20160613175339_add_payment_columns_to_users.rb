class AddPaymentColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :area_code, :string
    add_column :users, :phone, :integer
    add_column :users, :document, :integer
    add_column :users, :name, :string
    add_column :users, :hash_id, :string
    add_column :users, :postal_code, :string
    add_column :users, :street, :string
    add_column :users, :number, :integer
    add_column :users, :complement, :string
    add_column :users, :district, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :cc_token, :string
    add_column :users, :name_in_card, :string
    add_column :users, :birthdate, :date
    add_column :users, :document_card, :integer
  end
end
