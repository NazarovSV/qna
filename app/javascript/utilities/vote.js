$(document).on('turbolinks:load', function() {
    $('.question_rating').on('ajax:success', function (e) {
        let responce = e.detail[0];
        $("#" + responce["resource"] + "_rating_total_" + responce["id"]).html(responce["rating"])

        $("#" + responce["resource"] + "_rating_like_" + responce["id"]).attr('class', responce["like"] ? 'btn btn-primary' : 'btn btn-light')
        $("#" + responce["resource"] + "_rating_dislike_" + responce["id"]).attr('class', responce["dislike"] ? 'btn btn-primary' : 'btn btn-light')
    });
});