# frozen_string_literal: true

require 'nokogiri'
require 'uri'

module ExternalLinks
  def self.process(resource)
    site_hostname = URI(resource.site.config['url']).host
    link_selector = 'body a'

    unless resource.respond_to?(:asset_file?) && resource.asset_file?
      resource.output = process_content(
        site_hostname,
        resource.output,
        link_selector
      )
    end
  end

  def self.process_content(site_hostname, content, link_selector)
    content = Nokogiri::HTML(content)
    content.css(link_selector).each do |a|
      next unless a.get_attribute('href') =~ /\Ahttp/i
      next if a.get_attribute('href') =~ %r{\Ahttp(s)?://#{site_hostname}/}i

      a.set_attribute('rel', 'external')
      a.set_attribute('target', '_blank')
    end
    content.to_s
  end
end

Jekyll::Hooks.register :documents, :post_render do |doc|
  ExternalLinks.process(doc)
end

Jekyll::Hooks.register :pages, :post_render do |page|
  ExternalLinks.process(page)
end
