import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  consumer.subscriptions.create("QuestionsChannel", {
    connected() {},

    disconnected() {},

    received(data) {
      console.log(data)
      let questionTemplate = require('channels/templates/question.hbs')({
        question: data.question,
        question_url: data.question_url
      })
      $('.questions').append(questionTemplate)
      // if (gon.current_user_id !== data.user_id) {
      //   let answerTemplate = require('channels/templates/answer.hbs')({
      //     params: data,
      //     user_id: gon.current_user_id,
      //     is_question_author: gon.current_user_id === data.question_author_id
      //   })
      //   $('.answers').append(answerTemplate)
      // }
    }
  });
});
