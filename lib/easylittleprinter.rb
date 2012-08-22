require 'camping'
require 'date'


Camping.goes :LPImgApp


$imgFileExtension = ENV['EXTENSION']
$imgHostURL = ENV['HOSTURL']
$title = ENV['TITLE']
$sampleImg = ENV['SAMPLE']
$iconImg = ENV['ICON']
$publishes = ENV['FREQUENCY']

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
            if $publishes == "every_monday"
                if userDate.monday? == true
                    render :currentEdition
                else
                    r(200, "Error 200. Nothing to report, boss")
                end
            else if $publishes == "every_tuesday"
                if userDate.tuesday? == true
                    render :currentEdition
                else
                    r(200, "Error 200. Nothing to report, boss")
                end
            else if $publishes == "every_wednesday"
                if userDate.wednesday? == true
                    render :currentEdition
                else
                    r(200, "Error 200. Nothing to report, boss")
                end
            else if $publishes == "every_thursday"
                if userDate.thursday? == true
                    render :currentEdition
                else
                    r(200, "Error 200. Nothing to report, boss")
                end
            else if $publishes == "every_friday"
                if userDate.friday? == true
                    render :currentEdition
                else
                    r(200, "Error 200. Nothing to report, boss")
                end
            else if $publishes == "every_saturday"
                if userDate.saturday? == true
                    render :currentEdition
                else
                    r(200, "Error 200. Nothing to report, boss")
                end
            else if $publishes == "every_sunday"
                if userDate.sunday? == true
                    render :currentEdition
                else
                    r(200, "Error 200. Nothing to report, boss")
                end
            else if $publishes == "everyday"
                    render :currentEdition
            else if $publishes == "every_mwf"
                if userDate.monday? == true or userDate.wednesday? == true or userDate.friday? == true
                    render :currentEdition
                else
                    r(200, "Error 200. Nothing to report, boss")
                end
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
