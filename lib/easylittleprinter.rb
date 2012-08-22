require 'camping'
require 'date'
require 'camping/server'
require './lpconfig.rb'

module Settings #code from http://speakmy.name
  # again - it's a singleton, thus implemented as a self-extended module
  extend self

  @_settings = {}
  attr_reader :_settings

  # This is the main point of entry - we call Settings.load! and provide
  # a name of the file to read as it's argument. We can also pass in some
  # options, but at the moment it's being used to allow per-environment
  # overrides in Rails
  def load!(filename, options = {})
    newsets = YAML::load_file(filename).deep_symbolize
    newsets = newsets[options[:env].to_sym] if \
                                               options[:env] && \
                                               newsets[options[:env].to_sym]
    deep_merge!(@_settings, newsets)
  end

  # Deep merging of hashes
  # deep_merge by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
  def deep_merge!(target, data)
    merger = proc{|key, v1, v2|
      Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    target.merge! data, &merger
  end

  def method_missing(name, *args, &block)
    @_settings[name.to_sym] ||
    fail(NoMethodError, "unknown configuration root #{name}", caller)
  end

end

module EasyLittlePrinter
def self.do
  exec('camping '+ Dir.getwd)
end

Camping.goes :LPImgApp


$imgFileExtension = Settings.config[:imgFileExtension]
$imgHostURL = Settings.config[:imgHostUrl]
$title = Settings.config[:title]
$sampleImg = Settings.config[:sampleImg]
$iconImg = Settings.config[:iconImg]

module LPImgApp::Controllers

#If the user visits the root, the application uses
#plausible deniability. They shouldn't be there.

    class Root < R '/'
        def get
            p "Body? What body? I never heard of a body!"
        end
    end

#If the user requests /edition/, unless a local delivery time is
#not specified, the program checks whether it is a monday and, if
#it is, renders the current edition.

    class Edition < R '/edition/'
        def get
        
        @passedLDT = @input.local_delivery_time
        
	if @input.any? == false
            r(400, "No local_delivery_time. This is not the page you are looking for. Move along.")
        else
            userDate = Date.new
            userDate = Time.parse(@passedLDT)
            if userDate.monday? == true #change to .tuesday? etc, depending on the desired day
                render :currentEdition
            else
                r(200, "Error 200. Nothing to report, boss")
            end
        end
        end

    end
    
#Renders the static image sample

    class Sample <R '/sample/'
        def get
            render :sample
        end
    end

#Renders the icon

    class Icon <R '/icon.png'
        def get
            render :icon
        end
    end
#redirects to your offsite meta.json
    class MetaJson < R '/meta.json'
        def get
        redirect ($imgHostURL + "/meta.json")
        end
    end
end

module LPImgApp::Views
 
# wraps all code in the same format, with the title being the name
#specified at the top

 def layout
    html do
      head do
        title { $title }
            style :type => "text/css" do
                %[
            body { margin: 0 } #makes sure webkit doesn't add any margins
          ]
         end
      end
      body { self << yield }
    end
  end

#View the edition for the user's date.

  def currentEdition
    @parsedLDT = Date.parse(@passedLDT)
    img :src => $imgHostURL + "/" + @parsedLDT.to_s + $imgFileExtension
  end

#View for the sample

  def sample
    img :src => $imgHostURL + "/" + $sampleImg + $imgFileExtension
  end

#View for the icon

  def icon
    img :src => $imgHostURL + "/" + $iconImg + ".png"
  end

end
end
