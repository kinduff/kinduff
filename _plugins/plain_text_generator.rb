# frozen_string_literal: true

module Jekyll
  class PlainTextGenerator < Generator
    safe true
    priority :low

    def generate(site)
      config = site.config["plain_text_generator"] || {}
      return unless config.fetch("enabled", true)

      @include_collections = config.fetch("include_collections", ["posts"])
      @output_dir = config.fetch("output_dir", "")

      collections_to_process = [@include_collections].flatten

      collections_to_process.each do |collection_name|
        collection = site.collections[collection_name]
        next unless collection

        collection.docs.each do |doc|
          next if doc.data["draft"]

          plain_text_doc = PlainTextPost.new(site, doc, @output_dir)
          site.pages << plain_text_doc
        end
      end
    end
  end

  class PlainTextPost < Page
    def initialize(site, doc, output_dir = "")
      @site = site
      @base = site.source

      base_dir = File.dirname(doc.url)
      @dir = output_dir.empty? ? base_dir : File.join(output_dir, base_dir)
      @name = "#{File.basename(doc.url, ".html")}.txt"

      process(@name)

      plain_content = convert_to_plain_text(doc)

      self.content = plain_content
      self.data = {
        "layout"    => nil,
        "sitemap"   => false,
        "permalink" => File.join(@dir, @name),
      }
    end

    private

    def convert_to_plain_text(doc)
      output = []

      blog_title = @site.config["title"] || @site.config["name"] || "Blog"
      output << blog_title
      output << ""

      output << doc.date.strftime("%Y-%m-%d") if doc.date

      output << doc.data["title"] if doc.data["title"]

      output << "#{@site.config["url"]}#{doc.url}"
      output << ""

      begin
        raw_content = File.read(doc.path)
        content = raw_content.gsub(%r!\A---\s*\n.*?\n---\s*\n!m, "")
      rescue StandardError => e
        Jekyll.logger.warn "Plain Text Generator:", "Could not read file #{doc.path}: #{e.message}"
        content = doc.content
      end

      text_content = markdown_to_plain_text(content)

      output << text_content
      output << ""

      output.join("\n")
    end

    def markdown_to_plain_text(markdown)
      text = markdown.dup

      text = text.gsub(%r!\{%.*?%\}!, "")
      text = text.gsub(%r!\{\{.*?\}\}!, "")

      text = text.gsub(%r!\r\n?!, "\n")
      text = text.gsub(%r!\n{3,}!, "\n\n")
      text = text.gsub(%r![ \t]{2,}!, " ")
      text = text.gsub(%r!\n[ \t]+!, "\n")
      text = text.gsub(%r![ \t]+\n!, "\n")
      text.strip
    end
  end
end
