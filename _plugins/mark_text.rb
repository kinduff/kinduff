# frozen_string_literal: true

Jekyll::Hooks.register [:posts], :pre_render do |doc|
  doc.content.gsub!(%r!==+(\w(.*?)?[^ .=]?)==+!, '<mark>\\1</mark>')
end
