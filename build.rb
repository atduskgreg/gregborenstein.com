# home page
## links to projects
# /site
  # => output goes here
# /projects
#   /face_fight
#   /running_of_the_bulls
#     /images
#     /movies
#     links.txt (new line separated)
#     description.txt (or .html)

# tools: create a new project

module Portfolio
  class Link
    attr_accessor :href, :text
    def self.parse(text)
      parts = text.split(" ")
      self.new :text => parts[0..parts.length-2].join(" "), :href => parts.last
    end
    
    def initialize opts
      @href = opts[:href]
      @text = opts[:text]
    end
    
        
    def to_s
      "<a href='#{href}'>#{text}</a>"
    end
  end
  
  class Embed
  end
  
  class Movie
  end
  
  class Project
    attr_accessor :title, :description, :links, :location
    
    def initialize opts
      @title    = opts[:title]
      @location = opts[:location]
    end
    
    def self.load(dir_name)
      project = self.new :location => dir_name, 
                         :title => title_from_dir_name(dir_name.split("/").last)
      # TODO: rescue no description
      project.description = open("#{dir_name}/description.txt").read
      project.parse_links
      project
    end

    
    def parse_links
      @links = open("#{location}/links.txt").read.split(/\n/).collect{|l| Link.parse(l)}
    end
    
    def parse_embeds
    end
    
    def project_root
      "#{::WEB_ROOT}/projects/#{dir_name_from_title}"
    end
    
    def build_skeleton!
      FileUtils.mkdir_p project_root
      
      ["images", "movies"].each do |dir|
        FileUtils.mkdir_p "#{project_root}/#{dir}"
      end
      
      ["links", "description"].each do |f|
        FileUtils.touch "#{project_root}/#{f}.txt"
      end
    end
    
    def dir_name_from_title
      title.downcase.gsub(" ", "_")
    end
    
    def self.title_from_dir_name(dir_name)
      dir_name.gsub("_", " ").split(" ").collect{|w| w.capitalize}.join(" ")
    end
  end
end