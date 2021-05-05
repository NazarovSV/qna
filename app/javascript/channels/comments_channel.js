import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
    consumer.subscriptions.create({ channel: "CommentsChannel", room_id: $('.question').attr('data-question-id') }, {
        connected() {
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
            //console.log('QuestionChannel disconnected')
        },

        received(data) {
            console.log(data)
            if (gon.current_user_id !== data.comment.user_id) {
                let commentTemplate = require('channels/templates/comment.hbs')({
                    comment: data.comment,
                    email: data.email
                })
                console.log(commentTemplate)
                console.log('.' + data.resource_name + '-comments-' + data.comment.id)
                $('.' + data.resource_name + '-comments-' + data.comment.commentable_id).append(commentTemplate)
            }
        }
    });
});