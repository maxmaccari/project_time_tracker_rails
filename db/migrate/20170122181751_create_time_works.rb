class CreateTimeWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :time_works do |t|
      t.date :date, null: false, index: true
      t.text :description

      t.time :initial_time, null: false
      t.time :final_time

      t.references :project, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
