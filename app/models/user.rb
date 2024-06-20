# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable

  belongs_to :role

  has_many :orders, dependent: :restrict_with_exception

  validates :email, length: { maximum: 255 }
  validates :password,
            presence: true,
            length: {
              in: 8..20
            },
            on: :update,
            if: proc { |user| user.encrypted_password_changed? }
  validate :new_and_old_password_must_be_different

  with_options presence: true,
               length: {
                 minimum: 2,
                 maximum: 100
               },
               format: /\A([^\d\W]|-|\s)*\z/ do
    validates :first_name
    validates :last_name
  end

  before_validation :set_role, on: :create, if: -> { role_id.blank? }
  before_create :set_defaults

  def active_for_authentication?
    super && active?
  end

  def activate!
    update!(active: true) unless active?
  end

  def deactivate!
    update!(active: false) if active?
  end

  def admin?
    role.name.casecmp("administrator").zero?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    first_name.chr.concat(last_name.chr)
  end

  private

  def new_and_old_password_must_be_different
    return if changed.exclude?("encrypted_password")

    password_is_same = Devise::Encryptor.compare(User, encrypted_password_was, password)

    return unless password_is_same
    errors.add(:base, I18n.t("errors.messages.old_password_not_allowed"))
  end

  def set_role
    self.role = Role.find_or_create_by!(name: "Customer")
  end

  def set_defaults
    self.reset_password_token = SecureRandom.urlsafe_base64
  end
end
