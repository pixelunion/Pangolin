
#= require Theme/PostView

class Theme.PostsView extends Backbone.View

    events: {
        ## Click to Load Posts Handlers:
        #
        # 'click-to-load:end-of-posts'  : 'endOfPosts'
        # 'click-to-load:start-loading' : 'startedLoadingPosts'
        # 'click-to-load:done-loading'  : 'doneLoadingPosts'
        #
        ##
    }

    initialize: ->
        @morePostsURL = -1 # Infinite scroll defaults disabled.
        if Theme.options.click_to_load_posts and theme.isIndex and not theme.isMobile
            @setupClickToLoad()

        @postViews = []

    render: ->
        @setupPosts(@$ '.post')

    setupPosts: (posts) ->
        @addPost(post) for post in posts

    addPost: (post) ->
        postView = Theme.PostView.new({ el : post })
        postView.render()
        @postViews.push postView

    setupClickToLoad: ->
        nextButton = ($ '.pagination .next')
        if nextButton.length
            @morePostsURL = nextButton.attr('href')
        else
            @morePostsURL = -1
            @$el.trigger 'end-of-posts'

    fetchPosts: ->
        unless @morePostsURL == -1

            # Fire an event so we know we're loading.
            @$el.trigger 'click-to-load:start-loading'

            # A div outside the dom to store the elements
            # we are pulling in, temporarily.
            box = ($ '<div/>')

            # Fetch the posts, and the pagination. We fetch
            # the pagination so we can know if we just
            # fetch the last page of posts.
            box.load "#{@morePostsURL} .posts .post, .pagination", undefined, (data) =>
                if box.children().length != 0

                    newPosts = box.children('.post')

                    @$el.append newPosts
                    @setupPosts newPosts

                    # Fire an event so we know we're done loading.
                    @$el.trigger 'click-to-load:done-loading'

                    nextNextButton = box.find('.pagination .next')
                    if nextNextButton.length
                        @morePostsURL = nextNextButton.attr('href')
                    else
                        # We just fetch the last page.
                        @$el.trigger 'click-to-load:end-of-posts'

                    if Theme.options.facebook_comments
                        FB.XFBML.parse()

                    if @morePostsURL.indexOf('tagged') == -1 and @morePostsURL.indexOf('search') == -1
                        pageNumber = /page\/(\d+)/.exec @morePostsURL
                        pageNumber = parseInt(pageNumber[1], 10) if pageNumber

                        Tumblr.LikeButton.get_status_by_page(pageNumber-1)
                    else
                        ids = (($ post).attr('id') for post in newPosts)
                        Tumblr.LikeButton.get_status_by_post_ids(ids)


