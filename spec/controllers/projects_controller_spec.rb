# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    attributes_for(:project)
  end
  let(:invalid_attributes) do
    { title: '' }
  end

  before { sign_in user }

  describe 'GET #index' do
    let!(:project) { Project.create! valid_attributes }

    it 'assigns all projects as @projects' do
      get :index, params: {}

      expect(assigns(:projects)).to eq([project])
    end
  end

  describe 'GET #show' do
    let!(:project) { Project.create! valid_attributes }

    it 'assigns the requested project as @project' do
      get :show, params: { id: project.to_param }

      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'GET #new' do
    it 'assigns a new project as @project' do
      get :new, params: {}

      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe 'GET #edit' do
    let!(:project) { Project.create! valid_attributes }

    it 'assigns the requested project as @project' do
      get :edit, params: { id: project.to_param }

      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Project' do
        expect do
          post :create, params: { project: valid_attributes }
        end.to change(Project, :count).by(1)
      end

      it 'assigns a newly created project as @project' do
        post :create, params: { project: valid_attributes }

        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end

      it 'redirects to the created project' do
        post :create, params: { project: valid_attributes }

        expect(response).to redirect_to(Project.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved project as @project' do
        post :create, params: { project: invalid_attributes }

        expect(assigns(:project)).to be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        post :create, params: { project: invalid_attributes }

        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:parent) { create(:project) }
      let(:new_attributes) do
        { title: 'New Title', description: 'New Description',
          initial_date: Date.today, final_date: Date.today + 10,
          active: false, parent_id: parent.id }
      end

      let!(:project) { Project.create! valid_attributes }

      it 'updates the requested project' do
        put :update, params: { id: project.to_param, project: new_attributes }

        project.reload

        expect(project.title).to eq(new_attributes[:title])
        expect(project.description).to eq(new_attributes[:description])
        expect(project.initial_date).to eq(new_attributes[:initial_date])
        expect(project.final_date).to eq(new_attributes[:final_date])
        expect(project.active).to eq(new_attributes[:active])
        expect(project.parent_id).to eq(new_attributes[:parent_id])
      end

      it 'assigns the requested project as @project' do
        put :update, params: { id: project.to_param, project: valid_attributes }

        expect(assigns(:project)).to eq(project)
      end

      it 'redirects to the project' do
        put :update, params: { id: project.to_param, project: valid_attributes }

        expect(response).to redirect_to(project)
      end
    end

    context 'with invalid params' do
      let!(:project) { Project.create! valid_attributes }

      it 'assigns the project as @project' do
        put :update,
            params: { id: project.to_param, project: invalid_attributes }

        expect(assigns(:project)).to eq(project)
      end

      it "re-renders the 'edit' template" do
        put :update,
            params: { id: project.to_param, project: invalid_attributes }

        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:project) { Project.create! valid_attributes }

    it 'destroys the requested project' do
      expect do
        delete :destroy, params: { id: project.to_param }
      end.to change(Project, :count).by(-1)
    end

    it 'redirects to the projects list' do
      delete :destroy, params: { id: project.to_param }

      expect(response).to redirect_to(projects_url)
    end
  end
end
