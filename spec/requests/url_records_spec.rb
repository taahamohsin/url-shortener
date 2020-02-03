require "rails_helper"

RSpec.describe "UrlRecords" do
  let (:existing_record) do
    {
      id: 1,
      num_visits: 3
    }
  end
  describe 'create' do
    context "successfully returns an existing record" do
      before do
        allow(UrlRecord).to receive(:find_by_url).and_return([existing_record])
      end
      it 'responds with the record body with a 201' do
        post '/urls', params: { url: 'foo' }

        expect(JSON.parse(response.body).deep_symbolize_keys).to eq(existing_record)
        expect(response).to have_http_status(:ok)
      end
    end

    context "successfully creates a new record when there is no existing record for that url" do
      let (:new_record) do
        {
          id: 1
        }
      end

      before do
        allow(UrlRecord).to receive(:find_by_url).and_return([])
        allow(UrlRecord).to receive(:create_record).and_return(new_record)
      end
      it 'responds with the record body with a 201' do
        post '/urls', params: { url: 'foo' }
        expect(JSON.parse(response.body).deep_symbolize_keys).to eq(new_record)
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'stats' do
    context 'returns the url statistics for a shortened url that exists' do
      let(:existing_records) do
        [
          OpenStruct.new(
            id: 3,
            num_visits: 3
          )
        ]
      end
      before do
        allow(UrlRecord).to receive(:find_by_shortened_url).and_return(existing_records)
      end
      it 'responds with the record body with a 200' do
        get '/stats/foo'

        expect(JSON.parse(response.body)).to eq(existing_records.first.num_visits)
        expect(response).to have_http_status(:ok)
      end
    end
    
    context 'returns a 404 when the shortened url does not exist' do
      let(:existing_records) { [] }
      before do
        allow(UrlRecord).to receive(:find_by_shortened_url).and_return(existing_records)
      end

      it 'responds with a 404' do
        get '/stats/foo'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
  describe 'redirect' do
    context 'redirects for a shortened url that exists' do
      let(:existing_records) do
        [
          OpenStruct.new(
            id: 3,
            path: '/bar',
            num_visits: 3
          )
        ]
      end
      before do
        allow(UrlRecord).to receive(:find_by_shortened_url).and_return(existing_records)
      end
      it 'responds with the record body with a 200' do
        get '/redirect/foo'

        expect(response).to redirect_to('/bar')
        expect(response).to have_http_status(:found)
      end
    end
    
    context 'returns a 404 when the shortened url does not exist' do
      let(:existing_records) { [] }
      before do
        allow(UrlRecord).to receive(:find_by_shortened_url).and_return(existing_records)
      end

      it 'responds with a 404' do
        get '/redirect/foo'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end