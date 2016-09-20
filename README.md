![](https://cl.ly/2q3Q2Y0B0T0Y/pangolin-mark.svg)  
# Pangolin

**[Pixel Union](https://www.pixelunion.net)**'s very own Tumblr theme skeleton and build system, now open to everyone. Pangolin was built to help facilitate the rapid development of themes for the Tumblr platform. It provides a heavily opinionated suite of tools for every stage of the project.

Pangolin also includes pre-built functionality for [Open Graph](http://ogp.me) meta, Disqus and Facebook commenting, Google Analytics integration, Apple touch icons, 20+ social accounts, live load and click-to-load posts, [support for a marketing script](#marketing-helper), and so much more. :)

## Our Stack

#### Ruby

For overall asset watching, compiling, and serving. [Middleman](https://middlemanapp.com/) is used to serve styles and scripts, and a variety of Ruby helpers are used for templating and Tumblr settings.

#### Slim

We preprocess our HTML using [Slim](http://slim-lang.com).

#### CoffeeScript

We prefer [CoffeeScript](http://coffeescript.org) for JavaScript preprocessing. Additionally, we use class-based [Backbone](http://backbonejs.org) (+ [jQuery](https://jquery.com) and [Underscore](http://underscorejs.org)) for MVC. Views are available for Instagram, Flickr, and Twitter feeds.

#### SCSS

We preprocess CSS with SCSS and [Compass](http://compass-style.org). By default, [Normalize.css](http://necolas.github.io/normalize.css/) is used for cross-browser style resets.

#### PXU Photoset Extended

Additionally, the [PXU Photoset Extended](https://github.com/PixelUnion/Extended-Tumblr-Photoset) plugin is included in the source for custom Tumblr photosets.


## Theme Development

To get started on a new or existing Tumblr theme, use the following steps.

1. Clone this repo in to a new folder (or the repo of an existing theme).
2. `bundle install` to pull in the required gems.
3. Set the theme name in `config.rb`. (Not required if you're working on an existing theme.)
4. Start the development server with `bundle exec rake server`.

Develop! Middleman is now serving your CSS at [http://localhost:4567/styles/style.css](http://localhost:4567/styles/style.css) and your JavaScript at [http://localhost:4567/scripts/script.js](http://localhost:4567/scripts/script.js).

Because Tumblr doesn't support local theme development, you will need to paste the theme code in to your theme's Customize HTML area each time you change the markup. You can copy the theme code to your clipboard on every `.slim` file change with `bundle exec rake auto_build`.

**Note:** Tumblr now enforces assets to be served over HTTPS when in the Customize Theme screen, which Middleman does not do. This means that, for the moment, you won't be able to develop and live-customize your theme at the same time.

## Rake Tasks

The following Ruby rake commands are available for building the theme files.

- `bundle exec rake server` runs the Middleman development server at port 4567. It auto-builds and serves static assets for "local" development.
- `bundle exec rake auto_build` automatically builds the development file and copies it to the clipboard when any slim file is changed.
- `bundle exec rake build` builds all files, including assets. This minifies the styles and scripts.
- `bundle exec rake build_development` builds the development theme file and copies it to clipboard.
- `bundle exec rake build_production` builds only the production theme file.

## config.rb

Use `config.rb` to configure your development environment and theme settings.

#### `theme` and `version`

These are used when creating the theme's build filename (for example, `mytheme-v1.0.0.html`), the masthead (generated in `lib/theme_helpers.rb`), and in the footer.

#### `style_url` and `script_url`

After making changes to styles or scripts, you will need to upload the assets to Tumblr's [static asset CDN](https://www.tumblr.com/themes/upload_static_file). Once uploaded, update these two variables and build out the theme file. Your local static assets can be found at `your-theme/build/scripts|styles`.

#### `developer_name`, `developer_url`, and `purchase_url`

These are used in both the masthead and footer for informative and marketing purposes.

#### `demo_url` and `marketing_url`

Both of these variables are used in a `themeInfo` object. `marketing_url` should point to a script that can be injected on the page for marketing purposes. See [Marketing Helper](#marketing-helper) for more information.

## Ruby Helpers

#### `theme_header`

  Inserts a masthead into the code, with the theme name and version from `config.rb`.

#### `block`

  A helper for inserting Tumblr blocks into the code. Usage:

  ```
== block 'PreviousPage' do
  a.previous href="{PreviousPage}" {lang:Newer}
  ```

  will output:

  ```
{block:PreviousPage}<a class="previous" href="{PreviousPage}">lang:Newer</a>{/block:PreviousPage}
  ```

#### <div id="tumblroptions">`TumblrOptions`</div>

This provides a nice way to handle Tumblr's customize screen options. For in-depth usage see the `_TumblrOptions.slim` partial. The `add` method adds an option with the given type, name, and optionally a default value. The `:output` option determines whether or not a text option will be rendered literally by the `to_tumblr_json` method (which will break if the text option contains single quotes).

  The `to_tumblr_json` method outputs all the options added to the instance so far as a javascript object, inside of script tags. It becomes available as Theme.options.

## The `Theme` object

By default, `theme` is instantiated as a new `Theme` object. This object contains everything that powers the theme's core JavaScript on the page. Here's a run down of everything contained in the object:

#### `*View` and `PostTypes.*View`

As Backbone is used as Pangolin's JavaScript framework, these members are methods used to instantiate new Backbone views. Found in: `source/scripts/theme.js` and `source/scripts/Theme/*View.js.coffee`.

#### `helpers`

Various methods used to manipulate the page. Found in: `source/scripts/Theme/Helpers.js.coffee`.

#### `options`

Contains all publicly accessible theme options. See the Ruby helper [TumblrOptions](#tumblroptions) for more information. Found in: `source/layouts/_TumblrOptions.slim`.

## <div id="marketing-helper">Marketing Helper</div>

Pixel Union has developed a custom script that, when injected in to the DOM and the user is viewing either the Customize page or Demo URL, displays a small marketing widget. You are welcome to build your own, but make sure you set `demo_url` and `marketing_url`.

![Pixel Union's theme marketing widget](http://i.imgur.com/oqQuAuM.png?2)

See the source of `source/layouts/_MarketingWidget.slim` for more information.

## Structure

#### `index.html.slim`

  This layout file contains the basic structure of the page (everything inside the `body` tags). It references quite a few partials (found in `layouts/`).

#### `layouts/`

  Other than `index.html.slim`, all the layouts are in this folder.

  - `layout.slim` contains the "outer" portion of the theme, everything outside the `body` tags, plus the script inclusions that go at the end of the body.
  - `_TumblrOptions.slim` contains all the customization screen options. Any JavaScript variables or CSS properties dependent on the customization options should be in here too.
  - `_PermalinkContent.slim` contains comments, notes, and anything else that should only show on the permalink page.
  - `_PostMeta.slim` contains commment counts, timestamps, and any other post metadata.
  - `_Social.slim` contains the links to social media accounts.
  - `_MarketingWidget.slim` is for the marketing widget that is displayed on theme demos and on the customization screen.
  - `_OpenGraph.slim` contains the Open Graph meta for supporting Facebook sharing.

#### `PostTypes/`

This folder contains the partial for each post type.

#### `scripts/`

This folder contains all the JavaScript/CoffeeScript.

- `script.js` contains the "root" script file. All it does is require the rest of the javascript: jQuery, Underscore.js, Backbone.js, the plugins, the theme code.
- `libs/` stores any non-plugin JavaScript libraries in use.
- `plugins.js` for requiring any jQuery plugins.
- `plugins/` for storing any jQuery plugins.
- `external-feeds/` contains CoffeeScript for social feeds.
- `theme.js` just requires the Theme object and initializes the ThemeView.
- `Theme/` contains all the theme code.
	- `ThemeView.js.coffee` is the "root" view that sets everything up. It checks some settings and gets things going.
	- `PostView.js.coffee` is the superclass of all our posts. It contains any functionality shared by all post types.
	- `PostTypes/*PostView.js.coffee` is the functionality specific to each post type.
	- `PostsView.js.coffee` handles setting up the post views, infinite scrolling, etc.
	- `Helpers.js.coffee` contains any utility functions that need to be added.

#### `styles/`

All the stylesheets!

- `style.css.scss` includes the normalize styles, the clearfix, and pulls in all the theme styles.
- `_Theme.scss` includes the global theme styles and variables.
- `_Mixins.scss` for handy mixins.
- `_Post.scss` includes styles for all post types.
- `PostTypes/` includes styles for each individual post type.
- `extras/` for any additional styles. For example: the photoset plugin.

## Special Thanks

Pangolin has been touched by nearly every developer to walk through Pixel Union's doors, but it wouldn't be where it is today without the help of [Jared Norman](https://github.com/jarednorman), [Gray Gilmore](https://github.com/graygilmore), and [Philip McLaughlin](https://github.com/audiophil).

## Contributing

When contributing to Pangolin, keep a few things in mind:

- Take care to maintain the existing coding style, including indentation and naming conventions.
- If updating styles or scripts, be sure to `build_production`, upload the respective stylesheet or script to Tumblr's [static asset CDN](https://www.tumblr.com/themes/upload_static_file), and update the URL within `config.rb`.
- If updating markup, be sure to use the block helpers (`== block 'PreviousPage' do`) over standard Tumblr blocks (`{block:PreviousPage}...{/block:PreviousPage}`) when possible.
