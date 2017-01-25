class AddTrackingFieldsToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :estimated_time, :integer
    add_column :projects, :time_value, :decimal
    add_column :projects, :project_value, :decimal
  end
end
