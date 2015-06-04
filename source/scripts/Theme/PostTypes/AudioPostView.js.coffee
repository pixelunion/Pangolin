
class Theme.PostTypes.AudioPostView extends Theme.PostView

    events: _.extend({}, Theme.PostView::events, {
    })

    initialize: ->
        super()

    render: ->
        super()

    jsonData: (event, json) ->
        # Tumblr players break when pulled in via infinite scroll, fix 'em.
        audioPlayer = (@$ '.audio_player')
        if audioPlayer.length
            audioPlayer.html json['audio-player']


