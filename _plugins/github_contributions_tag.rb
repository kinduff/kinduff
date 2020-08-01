require 'githubchart'

class GithubContributionsTag < Liquid::Tag
  def initialize(tag_name, user, tokens)
    super
    @user = user.strip
  end

  def render(context)
    source = GithubChart.new({ user: @user }).render(:svg)
    content_type = 'image/svg+xml'
    encoding = 'charset=utf-8'
    data = CGI::escape(source).gsub('+', '%20')

    "<img src='data:#{content_type};#{encoding},#{data}' class='github-contributions' alt='#{@user}\'s Github contributions' />"
  end
end

Liquid::Template.register_tag('github_contributions', GithubContributionsTag)