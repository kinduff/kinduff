# frozen_string_literal: true

require "fastimage"

# source https://stackoverflow.com/a/64452457/992000
module ImageSizeFilter
  def image_size(source, dimension = nil)
    size = FastImage.size("./#{source["path"]}", :raise_on_failure => true)

    return size[0] if dimension == "w"
    return size[1] if dimension == "h"
    return size unless dimension

    raise "Invalid image size dimension requested: #{dimension}"
  end
end

Liquid::Template.register_filter(ImageSizeFilter)
