class CreatePaymentRequests < ActiveRecord::Migration
  def change
    create_table :payment_requests do |t|
      t.integer :area_code
      t.integer :phone
      t.integer :document
      t.string :email
      t.string :name
      t.string :hash_id
      t.integer :postal_code
      t.string :street
      t.integer :number
      t.string :complement
      t.string :district
      t.string :city
      t.string :state
      t.string :token
      t.string :name_in_card
      t.date :birthdate
      t.integer :document_card

      t.timestamps null: false
    end
  end
end
