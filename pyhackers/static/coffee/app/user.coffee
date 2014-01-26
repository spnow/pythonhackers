
class User
    postTemplate : window.Handlebars.compile($.trim($("#message-template").html()))
    projectTemplate: window.Handlebars.compile($.trim($("#project-template").html()))

    constructor : (@user_nick, @activeModule) ->
        console.log "Initialized"


    init : () ->
        $('a[data-toggle="tab"]').on('shown.bs.tab', (e) =>
          targetTab = $(e.target).attr("href")
          @loadModule(targetTab, e)
          # e.relatedTarget # previous tab
        )
        console.log "Initialized"

        @loadModule(@activeModule)

    loadModule: (target, evt) ->
        $tab = $('#user-tab')
        switch target
            when "#projects", "projects"
                if !evt?
                  $('#projects').addClass("active").siblings().removeClass("active")
                  $tab.find('a[href="#projects"]').parent().addClass("active").siblings().removeClass("active")
                do @loadProjects
            when "#timeline-container", "timeline"

                do @loadTimeline
            when "#discussions", "discussions"
                if !evt?
                  $('#discussions').addClass("active").siblings().removeClass("active")
                  $tab.find('a[href="#discussions"]').parent().addClass("active").siblings().removeClass("active")
                do @loadDiscussions
            else
                console.log "#{target} not found"

    loadProjects: () ->
        $projects = $("#projects")

        $.getJSON("/ajax/user/#{@user_nick}/projects",
            {_: new Date().getTime()},
            (data) =>
                console.log(data)
                $projects.html(@projectTemplate(
                    projects: data.projects
                ))
        )

    loadTimeline: () ->
        $timeline = $("#timeline")

        $.getJSON("/ajax/user/#{@user_nick}/timeline",
            {_: new Date().getTime(), after_id: @lastMessage or -1},
            (data) =>
                console.log(data)
                $timeline.html(@postTemplate(
                    message: data.timeline
                ))
        )
    loadDiscussions: () ->
        console.log("Load discussions")


$ ->
    user_nick = $("#user_nick").val()
    activeModule = $("#active_module").val()
    user = new User(user_nick, activeModule)
    user.init()



