class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.string :type, null: false, index: true

      t.date :date, null: false, index: true
      t.text :description

      t.integer :time, default: 0
      t.integer :initial_time, default: 0
      t.integer :final_time

      t.references :project, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
