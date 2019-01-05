# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecordsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:valid_attributes) do
    attributes_for(:amount_record, project_id: project.id)
  end
  let(:invalid_attributes) do
    { date: nil }
  end

  before { sign_in user }

  describe 'GET #show' do
    let(:record) { Record.create! valid_attributes }

    it 'assigns the requested record as @record' do
      get :show, params: { project_id: project.id, id: record.to_param }

      expect(assigns(:record)).to eq(record)
    end
  end

  describe 'GET #new' do
    before { get :new, params: { project_id: project.id } }

    it 'assigns a new record as @record' do
      expect(assigns(:record)).to be_a_new(Record)
    end

    it 'assigns the current date to the new record' do
      expect(assigns(:record).date).to eq(Date.current)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Record' do
        expect do
          post :create,
               params: { project_id: project.id, record: valid_attributes }
        end.to change(Record, :count).by(1)
      end

      it 'assigns a newly created record as @record' do
        post :create,
             params: { project_id: project.id, record: valid_attributes }

        expect(assigns(:record)).to be_a(Record)
        expect(assigns(:record)).to be_persisted
      end

      it 'redirects to the created record' do
        post :create,
             params: { project_id: project.id, record: valid_attributes }

        expect(response).to redirect_to(project)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved record as @record' do
        post :create,
             params: { project_id: project.id, record: invalid_attributes }

        expect(assigns(:record)).to be_a_new(Record)
      end

      it "re-renders the 'new' template" do
        post :create,
             params: { project_id: project.id, record: invalid_attributes }

        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    let!(:record) { Record.create! valid_attributes }

    context 'with valid params' do
      let(:new_attributes) do
        { description: 'A new description', hours: 10, minutes: 10 }
      end

      it 'updates the requested record' do
        put :update,
            params: {
              project_id: project.id,
              id: record.to_param,
              record: new_attributes
            }

        record.reload

        expect(record.description).to eq(new_attributes[:description])
        expect(record.hours).to eq(new_attributes[:hours])
        expect(record.minutes).to eq(new_attributes[:minutes])
      end

      it 'assigns the requested record as @record' do
        put :update,
            params: {
              project_id: project.id,
              id: record.to_param,
              record: valid_attributes
            }

        expect(assigns(:record)).to eq(record)
      end

      it 'redirects to the project' do
        put :update,
            params: {
              project_id: project.id,
              id: record.to_param,
              record: valid_attributes
            }

        expect(response).to redirect_to(project)
      end
    end

    context 'with opened record' do
      let!(:record) { create(:time_record, initial_hour: 0, project: project) }

      it 'closes the requested record' do
        put :update,
            params: {
              project_id: project.id,
              id: record.to_param,
              close: true
            }

        record.reload

        expect(record).to be_closed
      end

      it 'redirects to the project' do
        put :update,
            params: {
              project_id: project.id,
              id: record.to_param,
              record: valid_attributes
            }

        expect(response).to redirect_to(project)
      end
    end

    context 'with another day closing' do
      let!(:record) do
        create(:time_record, initial_hour: 23,
                             initial_minute: 59,
                             project: project)
      end

      it 'does not closes the requested record' do
        put :update,
            params: {
              project_id: project.id,
              id: record.to_param,
              close: true
            }

        record.reload

        expect(record).not_to be_closed
      end

      it 'redirects to the project' do
        put :update,
            params: {
              project_id: project.id,
              id: record.to_param,
              record: valid_attributes
            }

        expect(response).to redirect_to(project)
      end
    end

    context 'with invalid params' do
      it 'assigns the record as @record' do
        put :update, params: {
          project_id: project.id,
          id: record.to_param,
          record: invalid_attributes
        }

        expect(assigns(:record)).to eq(record)
      end

      it "re-renders the 'edit' template" do
        put :update, params: {
          project_id: project.id,
          id: record.to_param,
          record: invalid_attributes
        }

        expect(response).to render_template('show')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:record) { Record.create! valid_attributes }

    it 'destroys the requested record' do
      expect do
        delete :destroy, params: { project_id: project.id, id: record.to_param }
      end.to change(Record, :count).by(-1)
    end

    it 'redirects to the records list' do
      delete :destroy, params: { project_id: project.id, id: record.to_param }

      expect(response).to redirect_to(project)
    end
  end
end
