RSpec.describe 'Application', type: :feature do
    before(:example) do
      Capybara.app = Sinatra::Application.new
    end
    it 'exzample /' do
        visit '/'
        expect(page).to have_content('заявки')
      end
end