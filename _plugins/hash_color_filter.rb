# frozen_string_literal: true

module HashColorFilter
  def hash_color(input)
    "hsl(#{hash_code(input) % 360},  100%, 90%)"
  end

  private

  def hash_code(input)
    hash = 0
    input.each_byte do |c|
      hash = c + ((hash << 5) - hash)
    end
    hash
  end
end

Liquid::Template.register_filter(HashColorFilter)
