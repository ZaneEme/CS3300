require 'rails_helper'

RSpec.feature "Projects", type: :feature do

  user = FactoryBot.create(:user)

  context "Create new project" do
    before(:each) do
      Warden.test_mode!
      login_as(user, :scope => :user)
      visit new_project_path
      within(all("form")[1]) do
        fill_in "Title", with: "Test title"
      end
    end

    scenario "should be successful" do
      fill_in "Description", with: "Test description"
      click_button "Create Project"
      expect(page).to have_content("Project was successfully created")
    end

    scenario "should fail" do
      click_button "Create Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Update project" do
    let(:project) { Project.create(title: "Test title", description: "Test content") }
    before(:each) do
      Warden.test_mode!
      login_as(user, :scope => :user)
      visit edit_project_path(project)
    end

    scenario "should be successful" do
      visit edit_project_path(project)
      within(all("form")[1]) do
        fill_in "Description", with: "New description content"
      end
      click_button "Update Project"
      expect(page).to have_content("Project was successfully updated")
    end

    scenario "should fail" do
      Warden.test_mode!
      login_as(user, :scope => :user)
      visit edit_project_path(project)
      within(all("form")[1]) do
        fill_in "Description", with: ""
      end
      click_button "Update Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Remove existing project" do
    let!(:project) { Project.create(title: "Test title", description: "Test content") }
    scenario "remove project" do
      Warden.test_mode!
      visit project_path(project)
      login_as(user, :scope => :user)
      click_button "Destroy this project"
      expect(page).to have_content("Project was successfully destroyed")
      expect(Project.count).to eq(0)
    end
  end
end
