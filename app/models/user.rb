class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:github]

  delegate :pull_requests, :merge_pull_request, to: :client

  has_many :auto_merges, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.nickname = auth.info.nickname
      user.token = auth.credentials.token
      user.save
    end
  end

  def client
    @client ||= Octokit::Client.new(:access_token => token)
  end
end
