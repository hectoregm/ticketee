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

  context 'unsuccessful requests' do
    it 'doesnt allow requests that dont pass through an API key' do
      get url
      expect(response.status).to eql 401
      expect(response.body).to include 'Unauthenticated'
    end

    it 'doest allow requests that pass an invalid API key' do
      get url, {}, { 'HTTP_AUTHORIZATION' => 'Token token=notavalidkey' }
      expect(response.status).to eql 401
      expect(response.body).to include 'Unauthenticated'
    end

    it 'doesnt allow access to a ticket that the user doesnt have permission to read' do
      project.roles.delete_all
      get url, {}, headers
      expect(response.status).to eq 404
    end
  end
end
