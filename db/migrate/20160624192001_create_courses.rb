class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :price
      t.boolean :recurring
      t.string :period
      t.integer :cycles

      t.timestamps
    end
  end
end
