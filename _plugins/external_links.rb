# frozen_string_literal: true

require "nokogiri"
require "uri"

module ExternalLinks
  def self.process(resource)
    return if resource.data["layout"].nil?

    site_hostname = URI(resource.site.config["base_url"]).host
    link_selector = "body a"

    return if resource.respond_to?(:asset_file?) && resource.asset_file?

    resource.output = process_content(
      site_hostname,
      resource.output,
      link_selector
    )
  end

  def self.process_content(site_hostname, content, link_selector)
    content = Nokogiri::HTML(content)
    content.css(link_selector).each do |a|
      next unless %r!\Ahttp!i.match?(a.get_attribute("href"))
      next if %r!\Ahttp(s)?://#{site_hostname}!i.match?(a.get_attribute("href"))

      a.set_attribute("rel", "external")
      a.set_attribute("target", "_blank")

      next if a.children.size.positive? && a.children.map(&:name).include?("img")
      next if a.get_attribute("class")&.include?("skip-external")

      a.content = "#{a.content} ⧉"
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
