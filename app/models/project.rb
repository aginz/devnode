require 'elasticsearch/model'

class Project < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  acts_as_votable
  acts_as_taggable
  acts_as_followable

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  self.per_page = 10

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
                             :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # after_save do
  #   video_hash = JSON.parse(open("https://vimeo.com/api/oembed.json?url=#{self.video}").read)
  #   self.video_thumb = video_hash['thumbnail_url']
  #   self.save
  # end

  def video_embed
    video.gsub("vimeo.com/","player.vimeo.com/video/")
  end
  #https://vimeo.com/128028122
  # #Set video url to include http:// if not included
  # def set_video_url
  #   url = @project.video
  #   @project.video = full_url
  # end
  
  # #Check for full url
  # def full_url
  #   if url.match("http://") || url.match("http://")
  #     url = "http://"+url
  #   else
  #     url
  #  end
  #end
end

Project.import # for auto sync model with elastic search
