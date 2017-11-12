
Gollum::Filter::PlantUML.configure do |config|
    config.url = "http://localhost:4567/plantuml/svg"
end

GitHub::Markup::Markdown::MARKDOWN_GEMS['kramdown'] = proc { |content|
  Kramdown::Document.new(content, :auto_ids => false).to_html
}
