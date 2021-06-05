require 'rails_helper'

RSpec.describe Search do
  let!(:questions) { create_list(:question, 4) }
  let!(:answers) { create_list(:answer, 4)}
  let!(:comments) { create_list(:comment, 4, commentable: questions.first)}

  it 'will call Question search' do
    expect(Question).to receive(:search).and_return(questions.first)
    Search.call(request: questions.first.title, type: 'question')
  end


  it 'will call Answer search' do
    expect(Answer).to receive(:search).and_return(answers.first)
    Search.call(request: answers.first.body, type: 'answer')
  end


  it 'will call Comment search' do
    expect(Comment).to receive(:search).and_return(comments.first)
    Search.call(request: comments.first.body, type: 'comment')
  end


  it 'will call User search' do
    expect(User).to receive(:search).and_return(questions.first.user.email)
    Search.call(request: questions.first.user.email, type: 'user')
  end

  it 'will call ThinkingSphinx search' do
    expect(ThinkingSphinx).to receive(:search).and_return(questions.first)
    Search.call(request: questions.first.title, type: 'all')
  end
end
