class CreateAmountWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :amount_works do |t|
      t.date :date, null: false, index: true
      t.text :description
      t.integer :hours, null: false, default: 0
      t.integer :minutes, null: false, default: 0
      t.references :project, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
