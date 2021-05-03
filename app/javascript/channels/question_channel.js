import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
    consumer.subscriptions.create({ channel: "QuestionChannel", room_id: $('.question').attr('data-question-id') }, {
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
            //console.log('QuestionChannel disconnected')
        },

        received(data) {
            console.log(data)
            console.log(gon.current_user_id)
            console.log(data.question_author_id)
            if (gon.current_user_id !== data.user_id) {
                let answerTemplate = require('channels/templates/answer.hbs')({
                    params: data,
                    user_id: gon.current_user_id,
                    is_question_author: gon.current_user_id === data.question_author_id
                })
                console.log(answerTemplate)
                $('.answers').append(answerTemplate)
            }
        }
    });
});