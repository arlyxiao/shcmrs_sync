class MediaShare < ActiveRecord::Base
  belongs_to :media_resource
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  validates  :media_resource, :presence => true
  validates  :creator, :presence => true
  validates  :receiver, :presence => true

  # 给 User 类扩展方法，User类 include 这个 module
  module UserMethods
    def self.included(base)
      base.has_many :received_media_shares, :class_name => 'MediaShare', :foreign_key => :receiver_id
      base.has_many :received_shared_media_resources, :through => :received_media_shares, :source => :media_resource

      base.has_many :created_media_shares, :class_name => 'MediaShare', :foreign_key => :creator_id
      base.has_many :created_shared_media_resources, :through => :created_media_shares, :source => :media_resource

    end
  end


  # 给 MediaResource 类扩展方法，MediaResource 类 include 这个 module
  module MediaResourceMethods
    def self.included(base)
      base.has_many :media_shares
      base.has_many :shared_receivers, :through => :media_shares, :source => :receiver
    end
  end

end