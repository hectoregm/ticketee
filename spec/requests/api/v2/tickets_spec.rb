require 'rails_helper'

describe API::V2::Tickets do
  let(:project) { FactoryGirl.create(:project) }
  let(:user) { FactoryGirl.create(:user) }
  let(:ticket) { FactoryGirl.create(:ticket, project: project) }
  let(:url) { "/api/v2/projects/#{project.id}/tickets/#{ticket.id}" }

  let(:headers) do
    { 'HTTP_AUTHORIZATION' => "Token token=#{user.api_key}" }
  end

  before do
    assign_role!(user, :manager, project)
    user.generate_api_key
  end

  context 'successful requests' do
    it 'can view a tickets details' do
      get url, {}, headers

      expect(response.status).to eq 200
      json = TicketSerializer.new(ticket).to_json
      expect(response.body).to eq json
    end
  end
end
