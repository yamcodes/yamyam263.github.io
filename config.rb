## Gems ######################
require 'nokogiri'           # Scraping data
require 'open-uri'           # Fetching external websites
require 'slim'		         # Sexyfying HTML

## Directories ##############
set :css_dir, 'stylesheets' #
set :js_dir, 'javascripts'  #
set :images_dir, 'images'   #

set :relative_links, true

## Helpers #########################################
configure :development do                          #
		activate :livereload                       #
end                                                #
helpers do                                         #
	## Get link ######################################
	def schedule_link                                #
		## Variables ###################################
		url = "http://handasaim.co.il//"               # String: Site scraped
		data = Nokogiri::HTML(open(url))               #         Use HTML code
		link = "Error! No link."                       #         The link + default error
		items = data.css("marquee td *")               # Array:  All news items
		links = data.css("marquee a")                  #         All links
		xls = Array.new                                #         Only .xls links
		                                               #
		## List only .xls links ########################
		links.each do |a|                              # Iterate through all links #
			if a["href"].end_with? ".xls"              # 
				xls.push a["href"]                     #
			end                                        #
		end                                            #
		                                               #
		## Plan A: Get the first (and only) .xls link ##
		if xls.length == 1                             # Go to Plan A if only one .xls link exists
			link = xls[0]                                #
			                                             #
		## Plan B: Get the .xls link after "תועש תכרעמ" ##
		else                                            # Go to Plan B if several .xls links exist
			items.each do |a|                           # Iterate through all news items
				if a.text.include? "מערכת שעות"          # 
					link = a.next["href"]                    # 
				end                                        #
			end                                          #
		end                                            #
		                                               #
		link[link.index('h'), link.length]             #
	end                                              #
	                                                 #
## Get name ########################################
	def schedule_name                                #
		## Variables ###################################
		url = "http://handasaim.co.il//"               # String: Site scraped
		data = Nokogiri::HTML(open(url))               #         Use HTML code
		name = "מערכת שעות"                              #         The name + default value
		items = data.css("marquee b")                  # Array:  All news items
		                                               #
    ## Get name ####################################
		items.each do |a|                              # Iterate through all news items
			if a.text.include? "מערכת שעות"                # 
				name = a.text                              #
			end                                          #
		end                                            #
		                                               #
		name                                           #
	end                                              #
	                                                 #
end
activate :relative_assets