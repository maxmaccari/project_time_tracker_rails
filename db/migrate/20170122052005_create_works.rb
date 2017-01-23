class CreateWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :works do |t|
      t.string :type, null: false, index: true

      t.date :date, null: false, index: true
      t.text :description

      t.integer :initial_hour, null: false, default: 0
      t.integer :initial_minute, null: false, default: 0

      t.integer :final_hour
      t.integer :final_minute

      t.integer :hours, null: false, default: 0
      t.integer :minutes, null: false, default: 0

      t.references :project, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
