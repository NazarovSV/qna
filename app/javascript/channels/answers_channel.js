import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
    consumer.subscriptions.create({ channel: "AnswersChannel", room_id: $('.question').attr('data-question-id') }, {
        connected() {},

        disconnected() {},

        received(data) {
            if (gon.current_user_id !== data.user_id) {
                let answerTemplate = require('channels/templates/answer.hbs')({
                    params: data,
                    user_id: gon.current_user_id,
                    is_question_author: gon.current_user_id === data.question_author_id
                })
                $('.answers').append(answerTemplate)
            }
        }
    });
});