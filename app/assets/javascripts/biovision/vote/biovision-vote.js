"use strict";

const Votes = {
    initialized: false,
    autoInitComponents: true,
    components: {}
};

Votes.components.voteButtons = {
    initialized: false,
    buttons: [],
    url: "/votes",
    selector: ".vote-block .vote",
    init: function () {
        document.querySelectorAll(this.selector).forEach(this.apply);
        this.initialized = true;
    },
    apply: function (button) {
        const component = Votes.components.voteButtons;
        component.buttons.push(button);
        button.addEventListener("click", component.click);
    },
    click: function (event) {
        const component = Votes.components.voteButtons;
        const button = event.target;
        const delta = button.classList.contains("upvote") ? 1 : -1;
        const container = button.closest(".vote-block");
        const data = {
            "vote": {
                "votable_id": container.getAttribute("data-id"),
                "votable_type": container.getAttribute("data-type"),
                "delta": delta
            }
        };

        container.querySelectorAll(".vote").forEach(function (element) {
            element.disabled = true;
        });

        const onSuccess = function () {
            const result = JSON.parse(this.responseText);
            if (result.hasOwnProperty("meta")) {
                const meta = result.meta;

                container.classList.remove("voted-none");
                container.classList.add("voted-" + meta["vote_type"]);
                container.querySelector(".result").innerHTML = meta["vote_result"];
                button.classList.remove("switch");
            }
        };

        const onFailure = function () {
            button.classList.remove("switch");
            button.classList.add("error");

            Biovision.handleAjaxFailure();
        };

        const request = Biovision.jsonAjaxRequest("POST", component.url, onSuccess, onFailure);

        button.classList.add("switch");
        request.send(JSON.stringify(data));
    }
};

Biovision.components.votes = Votes;
