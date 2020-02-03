require "rails_helper"

RSpec.describe UrlRecord do
  let(:mock_record) { FactoryBot.build(:UrlRecord) }

  describe 'create_record' do
    before do
      allow(UrlRecord).to receive(:create).and_return(mock_record)
    end
    it 'successfully creates a UrlRecord with the given path' do
      record = UrlRecord.create_record('foo')
      expect(record.shortened_url).to eq(mock_record.shortened_url)
    end
  end

  describe 'increment_view_statistics' do
    it 'successfully increments view statistics by 1 for the given record' do
      initial_value = mock_record.num_visits
      mock_record.increment_visit_statistics
      expect(mock_record.num_visits).to eq(initial_value + 1)
    end
  end
end