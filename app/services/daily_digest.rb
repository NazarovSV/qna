class DailyDigest
  def send_digest
    questions = Question.new_question_from_the_last_day
    return if questions.empty?

    User.find_each(batch_size: 500) do |user|
       question_ids = questions.where.not(user_id: user.id).pluck(:id)
       DailyDigestMailer.digest(email: user.email, question_ids: question_ids).deliver_later
    end
  end
end
