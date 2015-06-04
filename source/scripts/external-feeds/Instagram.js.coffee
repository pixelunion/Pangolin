
# This a basic Instagram that pulls in a users most recent photos. Usage:
# Just point it at the element you want to contain the feed, and give it the
# access token. If passed anything falsy for the accessToken it will hide the
# given element, and not do anything.
#
# @instagram = new Instagram.Photostream {
#     el: (@$ '#instagram')
#     accessToken: instagramAccessToken
#     photoCount: 5
# }

window.Instagram = {}

# Instagram.Photo encapsulates each photo, along with its metadata, and
# provides some functions for easily accessing the important data.

class Instagram.Photo extends Backbone.Model

    likeCount:                  -> @get('likes')['count']
    commentCount:               -> @get('comments')['count']
    permalink:                  -> @get('link')
    imageURL: (size='standard') ->
        # accepts 'standard', 'low', 'thumbnail'
        size += '_resolution' if size != 'thumbnail'
        @get('images')[size]['url']
    filter: ->
        filter = @get('filter')
        if filter == 'Normal'
            'No filter'
        else
            filter

# Instagram.Photos encapsulates the logic belonging to the a given collection
# (or feed) of photos.

class Instagram.Photos extends Backbone.Collection

    model: Instagram.Photo
    url: ->
        "https://api.instagram.com/v1/users/self/media/recent?access_token=#{@accessToken}"

    initialize: (models, options) ->
        @accessToken = options.accessToken

    parse: (response) -> response.data

    fetch: ->
        super {
            type: "GET"
            dataType: "jsonp"
        }

# Instagram.PhotoView is responsible for rendering an individual photo. Modify
# the @template and @render to control how each photo is rendered.

class Instagram.PhotoView extends Backbone.View

    tagName: 'div'
    className: 'instagram-photo'
    template: _.template \
        """
        <a href="<%= permalink %>">
            <img src="<%= imageURL %>">

            <span class="likes">
                <%= like_text %>
            </span>
            <span class="comments">
                <%= comment_text %>
            </span>
            <span class="filter">
                <%= filter %>
            </span>
        </a>
        """

    initialize: ->
        @model.bind 'change', @render, this
        @model.bind 'destroy', @remove, this

    render: ->
        @$el.html @template {
            like_text:    do =>
                count = @model.likeCount()
                "#{count} #{_.pluralize('like', count)}"
            comment_text: do =>
                count = @model.commentCount()
                "#{count} #{_.pluralize('comment', count)}"
            filter:       @model.filter()
            permalink:    @model.permalink()
            imageURL:     @model.imageURL()
        }
        console.log @el
        @el

# Instagram.Photostream is responsible for rendering the Instagram feed
# itself.

class Instagram.Photostream extends Backbone.View

    initialize: ->
        accessToken = @options.accessToken
        if not accessToken
            @disabled = true
            @$el.hide()
            return

        @photoCount = @options.photoCount || 3

        @photos = new Instagram.Photos([], { accessToken: accessToken })
        @photos.bind('all', @render, this)
        @photos.fetch()

    render: ->
        if @disabled then return
        (@$ '.instagram-photo').remove()

        @photos.forEach (photo, index) =>
            if index >= @photoCount
                return
            view = new Instagram.PhotoView { model: photo }
            @$el.append view.render()


