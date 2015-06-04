
# This is a basic Flickr feed that pulls in the user's public photostream.
# Usage: Just point it at a target element, and give it a Flickr ID and a
# the number of photos desired.
#
# @flickr = new Flickr.Photostream {
#     el: ($ '#flickr')
#     flickrID: '69371462@N04'
#     photoCount: 10
# }

window.Flickr = {}

# Flickr.Photo encapsulates the data of each individual photo and provides
# some handy data access methods for accessing the externally relevant data.

class Flickr.Photo extends Backbone.Model

    title: -> @get('title')
    dateTaken: -> @get('datetaken')
    permalink: -> "http://www.flickr.com/photos/#{@get('owner')}/#{@get('id')}"
    photoURL: (size='largest') ->
        sizes = {
            'small thumbnail' : @get('url_s')
            'thumbnail'       : @get('url_t')
            '240px'           : @get('url_m')
            '640px'           : @get('url_z')
            '800px'           : @get('url_c')
            'original'        : @get('url_o')
        }
        if size == 'largest'
            sizesInOrder = [
                'original'
                '800px'
                '640px'
                '240px'
                'thumbnail'
                'small thumbnail'
            ]
            for s in sizesInOrder
                if sizes[s] != undefined then return sizes[s]
        else
            sizes[size]

# Flickr.Photos encapsulates the logic belonging to the the photostream
# (collection of photos).

class Flickr.Photos extends Backbone.Collection

    model: Flickr.Photo
    url: ->
        "http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&api_key=12a49355728ae8a0baa555cb07bcb767&user_id=#{@flickrID}&per_page=#{@photoCount}&page=1&extras=url_s,url_t,url_m,url_c,url_o,url_z,date_taken&format=json&jsoncallback=?"

    initialize: (models, options) ->
        @flickrID = options.flickrID
        @photoCount = options.photoCount || 3

    parse: (response) -> response.photos.photo

# Flickr.PhotoView is responsible for rendering an individual photo. Modify
# the @template and @render to control how each photo is rendered.

class Flickr.PhotoView extends Backbone.View

    tagName: 'div'
    className: 'photo'
    template: _.template \
        """
        <img src="<%= photoURL %>" />
        <p><%= caption %></p>
        <a href="<%= permalink %>" class="date"><%= date %></a>
        """

    initialize: ->
        @model.bind 'change', @render, this
        @model.bind 'destroy', @remove, this

    render: ->
        console.log @model.attributes
        @$el.html @template {
            photoURL  : @model.photoURL('largest')
            date      : @model.dateTaken()
            caption   : @model.title()
            permalink : @model.permalink()
        }
        @el

# Flickr.Photostream is responsible for rendering the Flickr feed itself.

class Flickr.Photostream extends Backbone.View

    initialize: ->
        flickrID = @options.flickrID
        if not flickrID
            @disabled = true
            @$el.hide()
            return
        photoCount = @options.photoCount
        @photos = new Flickr.Photos([], {
            flickrID   : flickrID
            photoCount : photoCount
        })
        @photos.bind('all', @render, this)
        @photos.fetch()

    render: ->
        if @disabled then return
        @$el.children('.photo').remove()
        @photos.forEach (photo, index) =>
            if index >= @photoCount then return
            view = new Flickr.PhotoView { model: photo }
            @$el.append view.render()


