class LPConfig

def self.imgFileExtension
 '.png' #the file extension of your images. You get one. Only one.
end

def self.imgHostUrl
'http://you.github.com' #the address of the static image server. No trailing slash. Github pages rocks for this
end

def self.title
'Imma Monkey!' #the title of your image serving pages. Purely cosmetic.
end

def self.sampleImg
'/sample' #the address of your sample image sans extension and trailing slash
end

def self.iconImg
'/icon' #the address of your icon image sans extension and trailing slash
end
end
