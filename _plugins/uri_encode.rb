# frozen_string_literal: true

module URIEncode
  def uri_encode(url)
    URI.encode_www_form_component(url)
  end
end

Liquid::Template.register_filter(URIEncode)
