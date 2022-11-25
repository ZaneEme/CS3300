require "rails_helper"
require_relative '../support/controller_macros'

RSpec.feature "Projects", type: :feature do

  login_user

  context "Create new project" do
    before(:each) do
      visit new_project_path
      within("form") do
        fill_in "title", with: "Test title"
      end
    end

    scenario "should be successful" do
      fill_in "description", with: "Test description"
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
      visit edit_project_path(project)
    end

    scenario "should be successful" do
      within("form") do
        fill_in "description", with: "New description content"
      end
      click_button "Update Project"
      expect(page).to have_content("Project was successfully updated")
    end

    scenario "should fail" do
      within("form") do
        fill_in "description", with: ""
      end
      click_button "Update Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Remove existing project" do
    let!(:project) { Project.create(title: "Test title", description: "Test content") }
    scenario "remove project" do
      visit project_path(project)
      click_button "Destroy this project"
      expect(page).to have_content("Project was successfully destroyed")
      expect(Project.count).to eq(0)
    end
  end
end
