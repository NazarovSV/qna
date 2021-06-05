require 'sphinx_helper'

feature 'User can search information', "
  In order to be able to find information
  As an user
  I want be able to search by resources
" do
  given!(:users) { create_list(:user, 4) }
  given!(:questions) { create_list(:question, 4) }
  given!(:answers) { create_list(:answer, 4, question: questions.first) }
  given!(:comments) { create_list(:comment, 3, commentable: questions.first) }

  before { visit root_path }

  describe 'search', js: true, sphinx: true do
    describe 'valid input' do
      scenario 'questions' do
        ThinkingSphinx::Test.run do
          fill_in 'request', with: questions.first.title
          select 'question', from: 'type'
          click_on 'Search'

          expect(page).to have_content questions.first.title

          questions.drop(1).each { |question| expect(page).to_not have_content question.title }
          answers.each { |answer| expect(page).to_not have_content answer.body }
          comments.each { |comment| expect(page).to_not have_content comment.body }
          users.each { |user| expect(page).to_not have_content user.email }
        end
      end

      scenario 'answers' do
        ThinkingSphinx::Test.run do
          fill_in 'request', with: answers.first.body
          select 'answer', from: 'type'
          click_on 'Search'

          expect(page).to have_content answers.first.body

          questions.each { |question| expect(page).to_not have_content question.title }
          answers.drop(1).each { |answer| expect(page).to_not have_content answer.body }
          comments.each { |comment| expect(page).to_not have_content comment.body }
          users.each { |user| expect(page).to_not have_content user.email }
        end
      end

      scenario 'comments' do
        ThinkingSphinx::Test.run do
          fill_in 'request', with: comments.first.body
          select 'comment', from: 'type'
          click_on 'Search'

          expect(page).to have_content comments.first.body

          questions.each { |question| expect(page).to_not have_content question.title }
          answers.each { |answer| expect(page).to_not have_content answer.body }
          comments.drop(1).each { |comment| expect(page).to_not have_content comment.body }
          users.each { |user| expect(page).to_not have_content user.email }
        end
      end

      scenario 'users' do
        ThinkingSphinx::Test.run do
          fill_in 'request', with: users.first.email
          select 'user', from: 'type'
          click_on 'Search'

          expect(page).to have_content users.first.email

          questions.each { |question| expect(page).to_not have_content question.title }
          answers.each { |answer| expect(page).to_not have_content answer.body }
          comments.each { |comment| expect(page).to_not have_content comment.body }
          users.drop(1).each { |user| expect(page).to_not have_content user.email }
        end
      end

      scenario 'all' do
        ThinkingSphinx::Test.run do
          fill_in 'request', with: users.first.email
          click_on 'Search'

          expect(page).to have_content users.first.email

          questions.each { |question| expect(page).to_not have_content question.title }
          answers.each { |answer| expect(page).to_not have_content answer.body }
          comments.each { |comment| expect(page).to_not have_content comment.body }
          users.drop(1).each { |user| expect(page).to_not have_content user.email }
        end
      end
    end

    describe 'invalid input' do
      scenario 'blank input' do
        click_on 'Search'

        expect(page).to have_content 'Request is empty'
      end

    end

  end
end