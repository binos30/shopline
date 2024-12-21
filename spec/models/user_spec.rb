# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "db_columns" do
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false, default: "") }
    it do
      is_expected.to have_db_column(:encrypted_password).of_type(:string).with_options(null: false, default: "")
    end
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:sign_in_count).of_type(:integer).with_options(null: false, default: 0) }
    it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:string) }
    it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:string) }
    it { is_expected.to have_db_column(:first_name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:last_name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:phone_number).of_type(:string) }
    it { is_expected.to have_db_column(:active).of_type(:boolean).with_options(null: false, default: true) }
    it { is_expected.to have_db_column(:role_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:gender).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:deleted_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:stripe_customer_id).of_type(:string) }
  end

  describe "db_indexes" do
    it { is_expected.to have_db_index(:active) }
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index(:first_name) }
    it { is_expected.to have_db_index(:last_name) }
    it { is_expected.to have_db_index(:gender) }
    it { is_expected.to have_db_index(:role_id) }
    it { is_expected.to have_db_index(:reset_password_token).unique }
    it { is_expected.to have_db_index(:stripe_customer_id).unique }
  end

  describe "associations" do
    describe "belongs_to" do
      # Use `without_validating_presence` with `belong_to` to prevent the
      # matcher from checking whether the association disallows nil (Rails 5+ only).
      # This can be helpful if you have a custom hook that always sets
      # the association to a meaningful value:
      it { is_expected.to belong_to(:role).inverse_of(:users).without_validating_presence }
    end

    describe "has_many" do
      it { is_expected.to have_many(:orders).inverse_of(:user).dependent(:restrict_with_exception) }
    end
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }

      subject! { create :user, password: "password" }

      context "if encrypted_password_changed? on update" do
        before { allow(subject).to receive(:encrypted_password_changed?).and_return(true) }

        it { should validate_presence_of(:password).on(:update) }
      end

      context "if not encrypted_password_changed? on update" do
        before { allow(subject).to receive(:encrypted_password_changed?).and_return(false) }

        it { should_not validate_presence_of(:password).on(:update) }
      end
    end

    describe "inclusion" do
      it { is_expected.to validate_inclusion_of(:gender).in_array(User.genders.keys) }
    end

    describe "length" do
      it { should validate_length_of(:email).is_at_most(255) }
      it { should validate_length_of(:first_name).is_at_least(2).is_at_most(100) }
      it { should validate_length_of(:last_name).is_at_least(2).is_at_most(100) }

      subject! { create :user, password: "password" }

      context "if encrypted_password_changed? on update" do
        before { allow(subject).to receive(:encrypted_password_changed?).and_return(true) }

        it { should validate_length_of(:password).on(:update).is_at_least(8).is_at_most(20) }
      end

      context "if not encrypted_password_changed? on update" do
        before { allow(subject).to receive(:encrypted_password_changed?).and_return(false) }

        it { should_not validate_length_of(:password).on(:update).is_at_least(8).is_at_most(20) }
      end
    end

    describe "format" do
      subject { build :user }

      it "first_name accepts a valid value" do
        subject.first_name = "John"
        expect(subject).to be_valid
      end

      it "first_name does not accept an invalid format" do
        subject.first_name = "John-1"
        expect(subject).to be_invalid
      end

      it "last_name accepts a valid value" do
        subject.last_name = "Doe"
        expect(subject).to be_valid
      end

      it "last_name does not accept an invalid format" do
        subject.last_name = "Doe-1"
        expect(subject).to be_invalid
      end
    end

    describe "before_validation .set_role" do
      subject { build :user, role: }

      let!(:role) { create :role, :as_admin }

      it "sets the role to Administrator" do
        subject.save!
        expect(subject.role.name).to eq("Administrator")
      end

      context "when the role_id is nil" do
        before { subject.role_id = nil }

        it "sets the role to Customer" do
          subject.save!
          expect(subject.role.name).to eq("Customer")
        end
      end
    end

    describe "new_and_old_password_must_be_different" do
      subject! { create :user, password: "password" }

      it "is valid" do
        expect(subject.valid?).to be true
      end

      context "when the password is similar to old" do
        before { subject.password = "password" }

        it "is has an error on password" do
          subject.validate
          expect(subject.errors[:password].first).to eq("Old password not allowed")
        end
      end
    end
  end

  describe "status" do
    subject { build :user }

    it "sets active to true" do
      expect(subject.active).to be true
    end

    describe ".deactivate!" do
      it "changes the active from true to false" do
        expect { subject.deactivate! }.to(change(subject, :active).from(true).to(false))
      end
    end

    describe ".activate!" do
      subject { build :user, active: false }

      it "changes the active from false to true" do
        expect { subject.activate! }.to(change(subject, :active).from(false).to(true))
      end
    end
  end

  describe ".active_for_authentication?" do
    subject { build :user }

    it "returns true" do
      expect(subject.active_for_authentication?).to be true
    end

    context "when active is false" do
      subject { build :user, active: false }

      it "returns false" do
        expect(subject.active_for_authentication?).to be false
      end
    end
  end

  describe ".admin?" do
    subject { build :user, :as_admin }

    it "returns true" do
      expect(subject.admin?).to be true
    end

    context "when the role is Customer" do
      subject { build :user }

      it "returns false" do
        expect(subject.admin?).to be false
      end
    end
  end

  describe ".customer?" do
    subject { build :user }

    it "returns true" do
      expect(subject.customer?).to be true
    end

    context "when the role is Administrator" do
      subject { build :user, :as_admin }

      it "returns false" do
        expect(subject.customer?).to be false
      end
    end
  end
end
