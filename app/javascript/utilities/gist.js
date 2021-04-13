$(document).on('turbolinks:load', function (){
    $('[data-gist-url]').each(function() {
        let url = $(this).data( "gist-url")
        $.ajax({
            url: url + '.json',
            dataType: 'jsonp',
            timeout: 1000,
            success: function (data) {
                if($('[href="' + data.stylesheet + '"]').length === 0) {
                    $(document.head).append('<link href="' + data.stylesheet + '" rel="stylesheet">')
                }
                $('[data-gist-url="'+ url+'"]').append(data.div)
            },
            error: function (data) {
                console.log(data)
            },
        })
    });
});