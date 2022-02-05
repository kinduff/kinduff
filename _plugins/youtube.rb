# frozen_string_literal: true

module Jekyll
  class YouTube < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @id = markup.strip
    end

    def render(_context)
      "<div class='youtube-container'><iframe src=\"https://www.youtube-nocookie.com/embed/#{@id}\">&nbsp;</iframe></div>"
    end
  end
end

Liquid::Template.register_tag("youtube", Jekyll::YouTube)
