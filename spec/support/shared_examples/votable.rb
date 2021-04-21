require 'rails_helper'

shared_examples 'Votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:votable) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  it 'should return the rating' do
    votable.like(user)
    votable.like(create(:user))

    expect(votable.rating).to eq(2)
  end

  it 'should like' do
    votable.like(user)

    user.reload

    expect(user.votes.last.value).to eq(1)
  end

  it 'should dislike' do
    votable.dislike(user)

    user.reload

    expect(user.votes.last.value).to eq(-1)
  end

  it 'should cancel the vote if already put the dislike' do
    votable.dislike(user)
    votable.dislike(user)

    user.reload
    expect(user.votes.last.value).to eq(0)
  end

  it 'should cancel the vote if already put the like' do
    votable.like(user)
    votable.like(user)

    user.reload
    expect(user.votes.last.value).to eq(0)
  end

  it "shouldn't change after like if user is author" do
    votable.like(votable.user)
    user.reload
    expect(user.votes.last&.value).to be_nil
  end

  it "shouldn't change after dislike if user is author" do
    votable.dislike(votable.user)
    user.reload
    expect(user.votes.last&.value).to be_nil
  end
end


