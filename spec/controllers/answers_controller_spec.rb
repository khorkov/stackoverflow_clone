require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  login_user

  let(:user) { create :user }
  let(:answer) { create :answer, user: user }
  let(:question) { create :question, user: user }

  describe 'POST create' do

    context 'create valid answer' do
      it 'save answer with valid parametrs' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'create invalid answer' do
      it 'should not save answer with invalid parametrs' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to change(question.answers, :count).by(0)
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assings the requested answer to @answer' do
        patch :update, question_id: question.id, id: answer, answer: { content: "new content" }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes question attributes' do
        patch :update, question_id: question.id, id: answer, answer: { content: "new content" }, format: :js
        answer.reload
        expect(answer.content).to eq 'new content'
      end
    end

    context 'invalid attributes' do
      before { patch :update, question_id: question.id, id: answer, answer: { content: nil }, format: :js }
      it 'does not change answer attributes' do
        answer.reload
        expect(answer.content).to eq answer.content
      end
    end
  end

  describe 'POST #destroy' do
    it "deletes answer" do
      create(:answer)
      expect { delete :destroy, question_id: answer.question_id, id: answer.id }.to change(Answer, :count).by(0)
    end
    it 'redirect to question view' do
      delete :destroy, question_id: answer.question_id, id: answer.id
      expect(response).to redirect_to question_path(answer.question)
    end
  end
end
