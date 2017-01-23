json.extract! project, :id, :title, :description, :parent_id, :initial_date, :final_date, :active, :created_at, :updated_at
json.url project_url(project, format: :json)