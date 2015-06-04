
# This is a basic Twitter feed using Backbone. Usage: Just point it at a jQuery
# element, and pass it the name of your Twitter user, and the number of tweets
# that you want to show. If passed anything falsy for the twitterName (an empty
# screen perhaps?), then it will hide() the given element.
#
# @twitter_feed = new Twitter.Feed {
#     el: (@$ '#twitter')
#     twitterName: 'jaredrnorman'
#     tweetCount: 3
# }

window.Twitter = {}

# Twitter.Tweet encapsulates the data of each individual tweet and provides
# some handy data access methods for accessing the externally relevant data.

class Twitter.Tweet extends Backbone.Model

    linkifiedText: ->
        @get('text')
            .replace(/((ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&?!\-\/]))?)/gi,'<a href="$1">$1</a>')
            .replace(/(^|\s)#(\w+)/g,'$1<a href="http://search.twitter.com/search?q=$2">#$2</a>')
            .replace(/(^|\s)@(\w+)/g,'$1<strong><a href="http://twitter.com/$2">@$2</a></strong>')

    timeAgo: ->
        date = @get('created_at')
        parsed_date = new Date(date.replace(/^\w+ (\w+) (\d+) ([\d:]+) \+0000 (\d+)$/, "$1 $2 $4 $3 UTC"))
        relative_to = new Date()

        delta = parseInt((relative_to - parsed_date) / 1000, 10)
        if delta < 60
            'less than a minute ago'
        else if delta < 120
            'about a minute ago'
        else if delta < 45*60
            parseInt(delta / 60, 10).toString() + ' minutes ago'
        else if delta < 90*60
            'about an hour ago'
        else if delta < 24*60*60
            'about ' + parseInt(delta / 3600, 10).toString() + ' hours ago'
        else if delta < 48*60*60
            '1 day ago'
        else
            parseInt(delta / 86400).toString() + ' days ago'

    permalink: ->
        "http://twitter.com/#{@username()}/status/#{@tweetID()}"

    retweetURL: ->
        "https://twitter.com/intent/retweet?tweet_id=#{@tweetID()}"

    replyURL: ->
        "https://twitter.com/intent/tweet?in_reply_to=#{@tweetID()}"

    favoriteURL: ->
        "https://twitter.com/intent/favorite?tweet_id=#{@tweetID()}"

    tweetID: ->
        @get 'id_str'

    username: ->
        @get('user').screen_name

# Twitter.Tweets encapsulates the logic belonging to the a given collection
# (or feed) of tweets.

class Twitter.Tweets extends Backbone.Collection

    model: Twitter.Tweet

    initialize: (models, options) ->
        @twitterName = options.twitterName
        @tweetCount  = options.tweetCount || 2

    comparator: (a, b) ->
        if new Date(a.toJSON().created_at) < new Date(b.toJSON().created_at)
            1
        else
            -1

# Twitter.TweetView is responsible for rendering an individual tweet. Modify
# the @template and @render to control how each tweet is rendered.

class Twitter.TweetView extends Backbone.View

    tagName: 'div'
    className: 'tweet'
    template: _.template \
        """
        <p><%= text %></p>
        <div class="meta">
            <a href="<%= permalink   %>" class="permalink"><%= date %></a>
            <a href="<%= favoriteURL %>" class="fav">fav</a>
            <a href="<%= retweetURL  %>" class="retweet">retweet</a>
            <a href="<%= replyURL    %>" class="reply">reply</a>
        </div>
        """

    initialize: ->
        @model.bind 'change', @render, this
        @model.bind 'destroy', @remove, this

    render: ->
        @$el.html @template {
            text:        @model.linkifiedText()
            date:        @model.timeAgo()
            permalink:   @model.permalink()
            favoriteURL: @model.favoriteURL()
            replyURL:    @model.replyURL()
            retweetURL:  @model.retweetURL()
        }
        @el

# Twitter.Feed is responsible for rendering the Twitter feed itself.
# Currently it includes standard Twitter follow button (if it isn't already
# present, builds the TweetViews, and renders them.

class Twitter.Feed extends Backbone.View

    initialize: ->
        @twitterName = @options.twitterName
        if not @twitterName
            @disabled = true
            @$el.hide()
            return
        @tweetCount = @options.tweetCount || 2

        @tweets = new Twitter.Tweets(window.tweet_data.slice(0, @tweetCount), {
            twitterName: @twitterName
            tweetCount: @tweetCount
        })
        @render()

    render: ->
        if @disabled then return
        @$el.css { display : 'block' }
        @$el.children('.tweet').remove()
        @tweets.forEach (tweet, index) =>
            view = new Twitter.TweetView { model: tweet }
            @$el.append view.render()
        if not (@$ '.twitter-follow-button').length
            @$el.append(
                """
                <a href="https://twitter.com/#{@twitterName}" class="twitter-follow-button" data-show-count="false">Follow @#{@twitterName}</a>
                <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
                """
            )


