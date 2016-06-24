class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.references :course, index: true
      t.string :full_name
      t.string :company
      t.string :email
      t.string :telephone
      t.text :notification_params
      t.string :status
      t.string :transaction_id
      t.datetime :purchased_at
      
      t.timestamps
    end
  end
end
