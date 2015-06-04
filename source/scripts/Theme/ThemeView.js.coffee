
#= require 'Theme/PostsView'

class Theme.ThemeView extends Backbone.View

    el: document.body

    initialize: ->
        html = ($ 'html')
        body = ($ document.body)

        # Do not initialize any views, or change the DOM inside this
        # method. Views initialized here will not be able to access
        # window.theme and thus these settings.

        @isMobile = html.hasClass('touch')
        @isIndex = body.hasClass('index-page')
        @isPermalinkPage = body.hasClass('permalink-page')
        @ltIE10 = html.hasClass('lt-ie10')

        if @ltIE10 then @placeholderFix()

        # TODO: Detect custom pages.

    render: ->
        @postsView = new Theme.PostsView { el : (@$ '.posts') }
        @postsView.render()

    placeholderFix: ->
        searchInput = ($ '.header-search-field')
        searchInput.val(Theme.options.lang_search)
            .on 'focus', ->
                if searchInput.val() is Theme.options.lang_search then searchInput.val('')
            .on 'blur', ->
                if searchInput.val() is '' then searchInput.val(Theme.options.lang_search)
