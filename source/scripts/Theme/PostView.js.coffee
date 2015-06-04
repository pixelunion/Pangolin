#= require_self

#= require Theme/PostTypes/PhotoPostView
#= require Theme/PostTypes/PhotosetPostView
#= require Theme/PostTypes/TextPostView
#= require Theme/PostTypes/AudioPostView
#= require Theme/PostTypes/VideoPostView
#= require Theme/PostTypes/AnswerPostView
#= require Theme/PostTypes/ChatPostView
#= require Theme/PostTypes/LinkPostView
#= require Theme/PostTypes/QuotePostView

Theme.PostTypes = {}

class Theme.PostView extends Backbone.View

    @new: (options) ->
        element = $(options.el || options.$el)
        classes = element.attr('class')
        postType = /type-(photo|photoset|text|audio|video|answer|chat|text|link|quote)\b/.exec(classes)[1]
        new Theme.PostTypes["#{ Theme.helpers.capitalize(postType) }PostView"](options)

    events: {
    }

    initialize: ->

    render: ->


