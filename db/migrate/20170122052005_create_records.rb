class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.string :type, null: false, index: true

      t.date :date, null: false, index: true
      t.text :description

      t.integer :initial_hour, default: 0
      t.integer :initial_minute, default: 0

      t.integer :final_hour
      t.integer :final_minute

      t.integer :hours, default: 0
      t.integer :minutes, default: 0

      t.references :project, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
