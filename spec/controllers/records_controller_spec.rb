require 'rails_helper'

RSpec.describe RecordsController, type: :controller do

  let(:user) { create(:user) }
  before(:each) { sign_in user }

  let(:project) { create(:project) }

  let(:valid_attributes) {
    attributes_for(:amount_record, project_id: project.id)
  }

  let(:invalid_attributes) {
    { date: nil }
  }

  describe "GET #show" do
    it "assigns the requested record as @record" do
      record = Record.create! valid_attributes
      get :show, params: {project_id: project.id, id: record.to_param}
      expect(assigns(:record)).to eq(record)
    end
  end

  describe "GET #new" do
    it "assigns a new record as @record" do
      get :new, params: {project_id: project.id}
      expect(assigns(:record)).to be_a_new(Record)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Record" do
        expect {
          post :create, params: {project_id: project.id, record: valid_attributes}
        }.to change(Record, :count).by(1)
      end

      it "assigns a newly created record as @record" do
        post :create, params: {project_id: project.id, record: valid_attributes}
        expect(assigns(:record)).to be_a(Record)
        expect(assigns(:record)).to be_persisted
      end

      it "redirects to the created record" do
        post :create, params: {project_id: project.id, record: valid_attributes}
        expect(response).to redirect_to(project)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved record as @record" do
        post :create, params: {project_id: project.id, record: invalid_attributes}
        expect(assigns(:record)).to be_a_new(Record)
      end

      it "re-renders the 'new' template" do
        post :create, params: {project_id: project.id, record: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {description: 'A new description', hours: 10, minutes: 10}
      }

      it "updates the requested record" do
        record = Record.create! valid_attributes
        put :update, params: {project_id: project.id, id: record.to_param, record: new_attributes}
        record.reload
        expect(record.description).to eq(new_attributes[:description])
        expect(record.hours).to eq(new_attributes[:hours])
        expect(record.minutes).to eq(new_attributes[:minutes])
      end

      it "assigns the requested record as @record" do
        record = Record.create! valid_attributes
        put :update, params: {project_id: project.id, id: record.to_param, record: valid_attributes}
        expect(assigns(:record)).to eq(record)
      end

      it "redirects to the record" do
        record = Record.create! valid_attributes
        put :update, params: {project_id: project.id, id: record.to_param, record: valid_attributes}
        expect(response).to redirect_to(project)
      end
    end

    context "with invalid params" do
      it "assigns the record as @record" do
        record = Record.create! valid_attributes
        put :update, params: {project_id: project.id, id: record.to_param, record: invalid_attributes}
        expect(assigns(:record)).to eq(record)
      end

      it "re-renders the 'edit' template" do
        record = Record.create! valid_attributes
        put :update, params: {project_id: project.id, id: record.to_param, record: invalid_attributes}
        expect(response).to render_template("show")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested record" do
      record = Record.create! valid_attributes
      expect {
        delete :destroy, params: {project_id: project.id, id: record.to_param}
      }.to change(Record, :count).by(-1)
    end

    it "redirects to the records list" do
      record = Record.create! valid_attributes
      delete :destroy, params: {project_id: project.id, id: record.to_param}
      expect(response).to redirect_to(project)
    end
  end

end
