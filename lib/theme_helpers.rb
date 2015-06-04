
module ThemeHelpers

  def theme_masthead
        <<eos
<!--
==========================================================================
   #{theme} #{version}
   Updated: #{Date.today.strftime "%B %d, %Y"}
   Download: #{purchase_url}
   #{developer_name}: #{developer_url}
==========================================================================
-->
eos
  end

  def block(name)
    "{block:#{name}}#{yield}{/block:#{name}}"
  end

  def toClasses(*args)
    classes = args.map do |blockName|
      blockOpen = "{block:#{blockName}}"
      blockClose = "{/block:#{blockName}} "
      className = blockName.to_s.tap do |name|
        name.sub!(/^If/, '')
        name.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1-\2')
        name.gsub!(/([a-z\d])([A-Z])/,'\1-\2')
        name.downcase!
        name
      end
      blockOpen + className + blockClose
    end
    classes.join
  end

  class TumblrOptions

    include Padrino::Helpers::TagHelpers

    def initialize
      @options = []
    end

    def add(type, name, options={:default => '', :output => false})
      @options.push({
        type: type,
        name: name,
        default: options[:default],
        output: options[:output]
      })
      tag :meta, :name => "#{type}:#{name}", :content => options[:default]
    end

    def add_select(name, default, options)
      result = ""
      add_option = lambda { |title, content|
        result += tag :meta, :name => "select:#{name}", :title => title, :content => content
      }
      add_option.call(default, options[default])
      options.each_pair do |key, content|
        unless key == default
          add_option.call(key, content)
        end
      end
      result
    end

    def to_tumblr_json
      output = "\n<script>Theme.options = {"
      @options.each_with_index do |option, index|
        property_name = option[:name].downcase.gsub(/ /, '_')
        case option[:type]
        when :text
          if option[:output]
            output += "{block:If#{ option[:name].gsub(/ /, '') }}#{property_name}: '{text:#{option[:name]}}'{/block:If#{ option[:name].gsub(/ /, '') }}"
          else
            output += "{block:If#{ option[:name].gsub(/ /, '') }}#{property_name}:true{/block:If#{ option[:name].gsub(/ /, '') }}"
          end
          output += "{block:IfNot#{ option[:name].gsub(/ /, '') }}#{property_name}:false{/block:IfNot#{ option[:name].gsub(/ /, '') }}"
        when :image
          output +=  "#{ property_name }_image: '{image:#{option[:name]}}'"
        when :color
          output += "#{ property_name }_color: '{color:#{option[:name]}}'"
        when :if
          output += "{block:If#{ option[:name].gsub(/ /, '') }}#{property_name}:true{/block:If#{ option[:name].gsub(/ /, '') }}"
          output += "{block:IfNot#{ option[:name].gsub(/ /, '') }}#{property_name}:false{/block:IfNot#{ option[:name].gsub(/ /, '') }}"
        end

        unless index == @options.length - 1
          output += ",\n"
        end
      end
      output += "};</script>\n"
      output
    end

  end

end

