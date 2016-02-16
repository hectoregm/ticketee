require 'rails_helper'

RSpec.feature 'Admin can create new users' do
  let(:admin) { FactoryGirl.create(:user, :admin) }

  before do
    login_as(admin)
    visit '/'
    click_link 'Admin'
    click_link 'Users'
    click_link 'New User'
  end

  scenario 'with valid credentials' do
    fill_in 'Email', with: 'newbie@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Create User'
    expect(page).to have_content 'User has been created.'
  end

  scenario 'when the new user is an admin' do
    fill_in 'Email', with: 'admin@xample.com'
    fill_in 'Password', with: 'password'
    check 'Is an admin?'
    click_button 'Create User'

    expect(page).to have_content 'User has been created.'
    expect(page).to have_content 'admin@xample.com (Admin)'
    end
end
