require 'media_wiki'

@snp = "Rs7412"
mw = MediaWiki::Gateway.new("http://bots.snpedia.com/api.php")
pages = mw.list(@snp + "(") # return an array of page-titles
if pages != nil
  pages.each do |p| # iterate over the results and grab the full text for each page
    single_page = mw.get(p)
    puts single_page
  end  # do
end  # if
