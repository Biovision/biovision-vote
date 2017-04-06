'use strict';

$(function () {
    $('.vote-block.active .vote').on('click', function () {
        var $button = $(this);
        var $container = $(this).closest('.vote-block');
        var votable_id = $container.data('id');
        var upvote = $(this).hasClass('upvote');
        var $form = $container.find('form');

        $('#vote_delta_' + votable_id).val(upvote ? '1' : '-1');

        if ($container.hasClass('active')) {
            $button.addClass('switch');

            $.post($form.attr('action'), $form.serialize(), function (result) {
                console.log(result);
                $button.removeClass('switch');
                if (result.hasOwnProperty('data')) {
                    var vote_type = result['data']['vote_type'];
                    var vote_result = result['data']['vote_result'];

                    $container.removeClass('voted-none');
                    $container.addClass('voted-' + vote_type);
                    $container.find('.result').html(vote_result);
                }
            }).fail(function(result) {
                $button.removeClass('switch');
                $button.addClass('error');
                handle_ajax_failure(result);
            });
        }

        $container.removeClass('active');
    });
});
