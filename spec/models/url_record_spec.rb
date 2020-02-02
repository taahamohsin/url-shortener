require "rails_helper"

RSpec.describe UrlRecord do

  describe 'create_record' do
    before do
      allow(UrlRecord).to receive(:create).and_return(UrlRecord.new(path: 'foo', num_visits: 0))
    end
    it 'successfully creates a UrlRecord with the given path' do
      record = UrlRecord.create_record('foo')
      expect(record.shortened_url).to eq('C')
    end
  end

  describe 'increment_view_statistics' do
    let(:mock_record) { object_double(UrlRecord, id: 1, num_visits: 0) }
    it 'successfully creates a UrlRecord with the given path' do
      mock_record.increment_view_statistics
      byebug
    end
  end
end