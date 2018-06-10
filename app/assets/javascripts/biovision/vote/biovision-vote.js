'use strict';

document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.vote-block.active .vote').forEach(function (element) {
        element.addEventListener('click', function () {
            const $button = this;
            const $container = $button.closest('.vote-block');
            const votable_id = $container.getAttribute('data-id');
            const upvote = $button.classList.contains('upvote');

            document.getElementById('vote_delta_' + votable_id).value = upvote ? '1' : '-1';

            if ($container.classList.contains('active')) {
                const $form = $container.querySelector('form');
                const on_success = function () {
                    const result = JSON.parse(this.responseText);

                    $button.classList.remove('switch');
                    if (result.hasOwnProperty('meta')) {
                        const vote_type = result['meta']['vote_type'];
                        const vote_result = result['meta']['vote_result'];

                        $container.classList.remove('voted-none');
                        $container.classList.add('voted-' + vote_type);
                        $container.querySelector('.result').innerHTML = vote_result;
                    }
                };

                const on_failure = function(result) {
                    $button.classList.remove('switch');
                    $button.classList.add('error');
                    handle_ajax_failure(result);
                };

                const request = Biovision.new_ajax_request('POST', $form.getAttribute('action'), on_success, on_failure);

                $button.classList.add('switch');

                request.send(new FormData($form));
            }

            $container.classList.remove('active');
        });
    });
});
