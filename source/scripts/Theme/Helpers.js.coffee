
# Helpers

Theme.helpers = {

    pluralize: (string, number) ->
        if number == 1 then string else string + 's'

    capitalize: (string) ->
        string.charAt(0).toUpperCase() + string.slice(1)

}

