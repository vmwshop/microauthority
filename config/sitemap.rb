require "yaml"
require 'csv'
settings = YAML.load_file "./config/settings.yaml"

SitemapGenerator::Sitemap.default_host = settings["domain"]
SitemapGenerator::Sitemap.public_path = "site/public"
SitemapGenerator::Sitemap.compress = true
SitemapGenerator::Sitemap.search_engines = settings["sitemap_notification_urls"]

SitemapGenerator::Sitemap.create do
  CSV.foreach("./data/data.csv", headers:true).sort_by{|row| row["sortName"] || row["name"]}.each do |row|
    add "/#{row["id"]}", :lastmod => row["updated_at"] || Time.now
  end
end
