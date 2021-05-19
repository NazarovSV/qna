require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) {nil}

    it { should be_able_to :read, Question}
    it { should be_able_to :read, Answer}
    it { should be_able_to :read, Comment}
    it { should be_able_to :create, User}
    it { should be_able_to :create, Authorization}

    it { should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user, confirmed_at: DateTime.now }
    let(:other) { create :user, confirmed_at: DateTime.now }
    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other }
    let(:answer) { create :answer, question: question, user: user }
    let(:other_answer) { create :answer, question: other_question, user: other }

    it { should_not be_able_to :manage, :all}
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Comment }

    context Question do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, user: user) }
      it { should_not be_able_to :update, create(:question, user: other) }

      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: other) }


      it { should be_able_to :like, create(:question, user: other)}
      it { should be_able_to :dislike, create(:question, user: other)}

      it { should be_able_to :comment, create(:question, user: user) }
    end


    context Answer do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, create(:answer, user: user) }
      it { should_not be_able_to :update, create(:answer, user: other) }

      it { should be_able_to :destroy, create(:answer, user: user) }
      it { should_not be_able_to :destroy, create(:answer, user: other) }

      it { should be_able_to :comment, create(:answer, user: user) }

      it { should be_able_to :best_answer, create(:answer, question: question, user: question.user)}
      it { should_not be_able_to :best_answer, create(:answer, question: other_question, user: user)}

      it { should be_able_to :like, create(:answer, user: other)}
      it { should be_able_to :dislike, create(:answer, user: other)}
    end

    context Link do
      it { should be_able_to :create, create(:link, linkable: question) }
      it { should_not be_able_to :create, create(:link, linkable: other_question) }

      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

      it { should be_able_to :create, create(:link, linkable:answer ) }
      it { should_not be_able_to :create, create(:link, linkable: other_answer) }

      it { should be_able_to :destroy, create(:link, linkable: answer) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_answer) }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end

  end
end