// Generated by CoffeeScript 1.6.3
(function() {
  var Application,
    _this = this;

  Application = {
    begin: function() {
      return $(this.load);
    },
    mixevents: function() {
      if (window.mixpanel == null) {
        return;
      }
      $("#mc_embed_signup").on("show.bs.modal", function() {
        return mixpanel.track("signup-popup");
      });
      mixpanel.track_links(".navbar a", "navlink", function(el) {
        var href;
        href = $(el).attr("href");
        if (href === "#mc_embed_signup") {
          return false;
          return {
            path: href.replace("#", ""),
            referrer: document.referrer
          };
        }
      });
      return _.defer(function() {
        return mixpanel.track("visit", {
          path: document.location.pathname
        });
      });
    },
    load: function() {
      Application.formSubmitter();
      return Application.mixevents();
    },
    captureSubmit: function($el) {
      var action, id, slug;
      action = $el.attr("action");
      if (!(action == null)) {
        action = action.replace("/ajax/", "");
      }
      id = $('[name="id"]', $el).val();
      slug = $('[name="slug"]', $el).val();
      return mixpanel.track(action, {
        referrer: document.referrer,
        id: id,
        slug: slug
      });
    },
    formSubmitter: function() {
      $('form[data-remote]').submit(function(evt) {
        var $this, action, postData;
        evt.preventDefault();
        evt.stopPropagation();
        Application.captureSubmit($(evt.currentTarget));
        if (!window.session.hasOwnProperty("id")) {
          document.location = '/authenticate';
          return;
        }
        $this = $(this);
        action = $this.attr("action");
        postData = $this.serializeArray();
        return $.post(action, postData);
      });
      return $('[data-toggle="tooltip"]').tooltip();
    }
  };

  Application.begin();

}).call(this);
