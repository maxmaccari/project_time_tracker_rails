class CreateTimeWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :time_works do |t|
      t.date :date, null: false, index: true
      t.text :description

      t.integer :initial_hour, null: false
      t.integer :initial_minute, null: false, default: 0

      t.integer :final_hour
      t.integer :final_minute

      t.references :project, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
