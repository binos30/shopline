# frozen_string_literal: true

class User < ApplicationRecord
  include Filterable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  # @NOTE:
  # The column `gender` is supposed to be of type string in the database.
  literal_enum :gender, %w[male female]

  belongs_to :role, inverse_of: :users

  has_many :orders, inverse_of: :user, dependent: :restrict_with_exception

  validates :gender, inclusion: { in: genders.keys }
  validates :email, length: { maximum: 255 }
  validates :password,
            presence: true,
            length: {
              in: 8..20
            },
            on: :update,
            if: proc { |user| user.encrypted_password_changed? }
  validate :new_and_old_password_must_be_different

  with_options presence: true, length: { minimum: 2, maximum: 100 }, format: /\A([^\d\W]|-|\s)*\z/ do
    validates :first_name
    validates :last_name
  end

  before_validation :set_role, on: :create, if: -> { role_id.blank? }
  before_create :set_defaults

  scope :customers,
        -> do
          select(
            "users.id, users.email, users.active,
            CONCAT(users.first_name, ' ', users.last_name) AS fullname,
            COUNT(orders.id) AS total_orders, COALESCE(SUM(orders.total), 0) AS total_spent"
          )
            .from(
              "users
              JOIN roles ON roles.id = users.role_id
              LEFT JOIN orders ON orders.user_id = users.id"
            )
            .where("LOWER(roles.name) = 'customer'")
            .group("users.id")
            .order(Arel.sql("CONCAT(users.first_name, ' ', users.last_name)"))
        end
  scope :filter_by_name, ->(name) { where("CONCAT(users.first_name, ' ', users.last_name) ILIKE ?", "%#{name}%") }

  # Overwrite the setter to rely on validations instead of [ArgumentError]
  # https://github.com/rails/rails/issues/13971#issuecomment-721821257
  def gender=(value)
    self[:gender] = value
  rescue ArgumentError
    self[:gender] = nil
  end

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete!
    update!(active: false, deleted_at: Time.current)
  end

  def active_for_authentication?
    super && active?
  end

  # provide a custom message for a deleted account
  def inactive_message
    deleted_at ? :deleted_account : super
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

  def customer?
    role.name.casecmp("customer").zero?
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
    errors.add(:password, I18n.t("devise.passwords.old_password_not_allowed"))
  end

  def set_role
    self.role = Role.find_or_create_by!(name: "Customer")
  end

  def set_defaults
    self.reset_password_token = SecureRandom.urlsafe_base64
  end
end
