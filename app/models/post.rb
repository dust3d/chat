class Post < ActiveRecord::Base
  belongs_to :user
  validates_associated :user
  validates :message, :presence => true

  before_save :geocode
  
  def geocode
    unless (self.lat.blank? || self.lon.blank?)
      loc=Geokit::Geocoders::GoogleGeocoder.reverse_geocode([self.lat, self.lon])
      self[:location] = "#{loc.city}, #{loc.state}" if loc.success
    end
  end
  
end
