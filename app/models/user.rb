#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class User < ActiveRecord::Base
  extend Memoist
  extend Tokenize
  extend RailsAdminStatistics

  # Friendly_id for beautiful links
  extend FriendlyId

  friendly_id :nickname, use: [:slugged, :finders]

  include Associations, ExtendedAttributes, Validations, State, Ratings
  include Assets::Normalizer # for cancellation form

  # Include default devise modules. Others available are: :rememberable,
  # :token_authenticatable, :encryptable, :lockable,  and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :trackable, :validatable, :confirmable

  after_create :create_default_library


  ####################################################
  # Scopes
  #
  ####################################################
  scope :sorted_ngo, -> { order(:nickname).where(ngo: true) }
  scope :ngo_with_profile_image, -> { where(ngo: true).joins(:image).limit(6) }


  ####################################################
  # Methods
  #
  ####################################################

  # Return first_name plus last_name
  # @api public
  # @return [String]
  def fullname
    "#{standard_address_first_name} #{standard_address_last_name}"
  end
  # memoize :fullname

  # Return user nickname
  # @api return
  # @public [String]
  def name
    nickname
  end

  # Return user first name
  # @api return
  # @public [String]
  def first_name
    standard_address_first_name
  end

  # Compare IDs of users
  # @api public
  # @param user [User] Usually current_user
  def is?(user)
    user && self.id == user.id
  end

  # Check if user was created before Sept 24th 2013
  # @api public
  # @param user [User] Usually current_user
  def is_pioneer?
    self.created_at < Time.parse("2013-09-23 23:59:59.000000 CEST +02:00")
  end

  # Static method to get admin status even if current_user is nil
  # @api public
  # @param user [User, nil] Usually current_user
  def self.is_admin?(user)
    user && user.admin?
  end

  # Get generated customer number
  # @api public
  # @return [String] 8-digit number
  def customer_nr
    id.to_s.rjust 8, "0"
  end

  # Get url for user image
  # @api public
  # @param symbol [Symbol] which type
  # @return [String] URL
  def image_url(symbol)
    image ? image.image.url(symbol) : ActionController::Base.helpers.asset_path('missing.png')
  end

  # Return a formatted address
  # @api public
  # @return [String]
  def address
    string = ""
    string += "#{standard_address_address_line_1}, "
    string += "#{standard_address_address_line_2}, " if standard_address_address_line_2.present?
    string += "#{standard_address_zip} #{standard_address_city}"
    string
  end

  # get ngo status
  # @api public
  def is_ngo?
    self.ngo
  end

  # get all users with ngo status but not current
  def self.sorted_ngo_without_current(current_user)
    self.order(:nickname).where("ngo = ? AND id != ?", true, current_user.id)
  end

  # get hearted libraries of current user
  def self.hearted_libraries_current(current_user)
    if current_user
      current_user.hearted_libraries.published.
                   no_admins.min_elem(2).
                   where('users.id != ?', current_user.id).
                   reorder('hearts.created_at DESC')
    end
  end

  def bank_account_exists?
    self.bank_account_owner? && self.iban? && self.bic?
  end

  def paypal_account_exists?
    self.paypal_account?
  end

  # checks if user passes all neccessary validations before he can sell
  def can_sell?
    self.wants_to_sell = true
    can_sell = self.valid?
    self.wants_to_sell = false
    can_sell
  end

  # Notify the user of an asynchron event
  # @api public
  # @param message [String] Message that is shown to a user
  # @param color [Symbol] see NoticeHelper for the different types of flash notices
  # @param path [String] the Path (relative URL) to which the message should lead the user
  def notify message, path , color = :notice
    unless self.notices.where(message: message, path: path, open: true).any?
      self.notices.create message: message, open: true, path: path, color: color
    end
  end

  # Returns the next open notice of this user
  # @api public
  # @return [Notice] the notice
  def next_notice
    self.notices.where(open: true).first
  end

  # hashes the ip-addresses which are stored by devise :trackable
  def last_sign_in_ip= value
    super Digest::MD5.hexdigest(value)
  end

  def current_sign_in_ip= value
    super Digest::MD5.hexdigest(value)
  end

  # FastBill: this method checks if a user already has fastbill profile
  def has_fastbill_profile?
    fastbill_id && fastbill_subscription_id
  end

  # FastBill
  def update_fastbill_profile
    if self.has_fastbill_profile?
      FastbillAPI.update_profile self
    end
  end

  def count_value_of_goods
    value_of_goods_cents = self.articles.active.sum("price_cents * quantity")
    self.update_attribute(:value_of_goods_cents, value_of_goods_cents)
  end

  # Should work with has_many :article_templates, -> { where(state: :template) }, class_name: 'Article'
  # but it does not!
  def article_templates
    Article.unscoped.where(state: :template, seller: self.id)
  end

  def save_already_validated_standard_address!
    if self.standard_address
      self.standard_address = self.standard_address.duplicate_if_referenced!
      self.standard_address.save!(validate: false) # Already validates with validates_associates in user model
      self.update_column(:standard_address_id, self.standard_address.id)
    end
  end

  def build_standard_address_from address_params
    self.standard_address ||= self.addresses.build if address_params.select{ |param,value| !value.empty? }.any?
    self.standard_address.assign_attributes(address_params) if self.standard_address
  end

  def unified_transport_available?
    self.unified_transport_provider.present? &&
    self.unified_transport_maximum_articles.present? &&
    self.unified_transport_maximum_articles > 1 &&
    self.unified_transport_price_cents.present?
  end

  private

    # @api private
    def create_default_library
      if self.libraries.empty?
        Library.create(name: I18n.t('library.default'), public: false, user_id: self.id)
      end
    end

    def wants_to_sell?
      self.wants_to_sell
    end

    def is_german?
      self.standard_address && self.standard_address.country == "Deutschland"
    end
end
