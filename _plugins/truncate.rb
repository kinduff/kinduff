# frozen_string_literal: true

module TruncateFilter
  def truncate(input, truncate_at = 140, separator = nil, omission = "...")
    return input.dup unless input.length > truncate_at

    length_with_room_for_omission = truncate_at - omission.length
    stop = if separator
             input.rindex(separator, length_with_room_for_omission) ||
               length_with_room_for_omission
           else
             length_with_room_for_omission
           end

    "#{input[0...stop]}#{omission}"
  end
end

Liquid::Template.register_filter(TruncateFilter)
