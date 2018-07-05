# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'SecureRandom'
require 'visit'

class ShortenedUrl < ApplicationRecord
  include SecureRandom
  
  validates :long_url, :user_id, presence: true
  validates :short_url, presence: true, uniqueness: true
  
  belongs_to :submitter,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :User
  
  has_many :visits,
  primary_key: :id,
  foreign_key: :shortened_url_id,
  class_name: :Visit
  
  has_many :visitors,
  through: :visits,
  source: :user
  
  
  def self.random_code
    new_url = SecureRandom.urlsafe_base64(8)
    while ShortenedUrl.exists?(new_url)
      new_url = SecureRandom.urlsafe_base64(8)
    end
    new_url
  end
  
  def self.create_shortened_link(user, long_url)
    new_url = ShortenedUrl.random_code
    a = ShortenedUrl.create!(user_id: user.id, long_url: long_url, short_url: new_url)
    Visit.record_visit!(user, a)
    return a
  end
  
  def num_clicks
    self.visitors.select(:id).count
  end
  
  def num_uniques
    self.visitors.select(:id).distinct.count
  end
  
  def num_recent_uniques
    self.visitors.select(:id).distinct.where({created_at: 2.hour.ago..(Time.now.utc)})
  end
  
end
