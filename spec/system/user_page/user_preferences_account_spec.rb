# frozen_string_literal: true

describe "User preferences for Account", type: :system do
  fab!(:user) { Fabricate(:user) }
  let(:user_account_preferences_page) { PageObjects::Pages::UserPreferencesAccount.new }
  let(:avatar_selector_modal) { PageObjects::Modals::AvatarSelector.new }
  before { sign_in(user) }

  describe "avatar-selector modal" do
    it "saves custom picture and system assigned pictures" do
      user_account_preferences_page.open_avatar_selector_modal(user)
      expect(avatar_selector_modal).to be_open

      avatar_selector_modal.select_avatar_upload_option
      file_path = File.absolute_path(file_from_fixtures("logo.jpg"))
      attach_file(file_path) { avatar_selector_modal.click_avatar_upload_button }
      expect(avatar_selector_modal).to have_user_avatar_image_uploaded
      avatar_selector_modal.click_primary_button
      expect(avatar_selector_modal).to be_closed
      expect(user_account_preferences_page).to have_custom_uploaded_avatar_image

      user_account_preferences_page.open_avatar_selector_modal(user)
      avatar_selector_modal.select_system_assigned_option
      avatar_selector_modal.click_primary_button
      expect(avatar_selector_modal).to be_closed
      expect(user_account_preferences_page).to have_system_avatar_image
    end
  end
end
