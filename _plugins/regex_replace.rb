# frozen_string_literal: true

module RegexReplace
  def regex_replace(input, regex, value)
    formatted_regex = %r!#{regex}!
    input.gsub(formatted_regex, value)
  end

  def clean_urls(input)
    regex_replace(input.delete("…"), '(?<=^|[\s,])([\w-]+\.[a-z]{2,}\S*)\b', "")
  end
end

Liquid::Template.register_filter(RegexReplace)
