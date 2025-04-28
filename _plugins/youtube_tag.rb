class YouTubeTag < Liquid::Tag
  def initialize(tag_name, markup, tokens)
    super
    args = markup.split
    @id = args[0].strip
  end

  def render(_context)
    domain = "www.youtube.com"
    "<div class='youtube-container'><iframe src=\"https://#{domain}/embed/#{@id}\" frameborder='0' allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share' referrerpolicy='strict-origin-when-cross-origin' allowfullscreen></iframe></div>"
  end
end

Liquid::Template.register_tag("youtube_tag", YouTubeTag)
