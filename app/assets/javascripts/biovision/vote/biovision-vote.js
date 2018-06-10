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

                const on_failure = function (result) {
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

    document.querySelectorAll('[data-vote]').forEach(function (button) {
        const container = button.closest('[data-vote-url]');
        if (container) {
            console.log(container);
            if (container.classList.contains('vote-active')) {
                const url = container.getAttribute('data-vote-url');

                button.addEventListener('click', function () {
                    const delta = this.getAttribute('data-vote') === 'up' ? 1 : -1;
                    const pressedButton = this;

                    /**
                     * Во время голосования состояние переключается
                     * на vote-inactive, поэтому проверяем ещё раз
                     */
                    if (container.classList.contains('vote-active')) {
                        const data = {
                            vote: {
                                votable_id: container.getAttribute('data-votable-id'),
                                votable_type: container.getAttribute('data-votable-type'),
                                delta: delta,
                            }
                        };

                        const request = Biovision.jsonAjaxRequest('POST', url, function () {
                            if (this.responseText) {
                                const response = JSON.parse(this.responseText);

                                if (response.hasOwnProperty('meta')) {
                                    if (delta > 0) {
                                        pressedButton.innerHTML = response.meta['upvote_count'];
                                    } else {
                                        pressedButton.innerHTML = response.meta['downvote_count'];
                                    }
                                    container.classList.remove('voted-none');
                                    container.classList.add('voted-' + response.meta['vote_type']);
                                }
                            } else {
                                container.classList.remove('vote-inactive');
                                container.classList.add('vote-active');
                            }
                        });

                        container.classList.remove('vote-active');
                        container.classList.add('vote-inactive');

                        request.send(JSON.stringify(data));
                    }
                });
            }
        }
    });
});
