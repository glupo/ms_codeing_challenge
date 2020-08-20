# frozen_string_literal: true

class CustomClass < Contentful::Objects::Base; end

describe Contentful::Objects::Base do
  let(:client) { create_client }
  let(:array) { vcr('array') { client.entries } }
  let(:content_type) { CustomClass.content_type }
  let(:mock_client) { instance_double(Contentful::Client) }

  describe ".find" do
    let(:id) { element.id }
    let(:element) { array.to_a.first }
    let(:search_result) { vcr('search_by_id') { client.entries('sys.id' => id) } }

    before do
      allow(mock_client).to receive(:entries).with(content_type: content_type, 'sys.id' => id).and_return(search_result)
      allow(CustomClass).to receive(:new).with(element).and_call_original
      allow(CustomClass).to receive(:client).and_return(mock_client)
    end

    it "queries client for requested element" do
      CustomClass.find(id)

      expect(mock_client).to have_received(:entries)
    end

    it "creates instance of self with found entry" do
      expect(CustomClass.find(id)).to be_instance_of CustomClass
    end

    context "when there are no such records" do
      let(:search_result) { vcr('empty_search_by_id') { client.entries('sys.id' => 'fake_id') } }

      it "doesn't instantiate new object" do
        CustomClass.find(id)

        expect(CustomClass).not_to have_received(:new)
      end

      it 'returns nil' do
        expect(CustomClass.find(id)).to be_nil
      end
    end
  end

  describe ".load" do
    let(:search_result) { array }
    let(:limit) { Faker::Number.number(digits: 2) }
    let(:offset) { Faker::Number.number(digits: 2) }

    before do
      allow(mock_client).to receive(:entries).with(content_type: content_type, limit: limit, skip: offset).and_return(search_result)
      allow(CustomClass).to receive(:new).and_call_original
      allow(CustomClass).to receive(:client).and_return(mock_client)
    end

    it "calls client with provided params" do
      CustomClass.load(limit: limit, offset: offset)

      expect(mock_client).to have_received(:entries)
    end

    it "crates new instances for each result" do
      CustomClass.load(limit: limit, offset: offset)

      expect(CustomClass).to have_received(:new).exactly(search_result.count).times
    end

    it "returns an array of instances", :aggregate_failures do
      result = CustomClass.load(limit: limit, offset: offset)

      expect(result).to be_instance_of Array
      expect(result.size).to eq(search_result.count)
      expect(result).to all( be_instance_of CustomClass )
    end

    context "when there are no records" do
      let(:search_result) { vcr('empty_search_by_id') { client.entries('sys.id' => 'fake_id') } }

      it "doesn't instantiate new objects" do
        CustomClass.load(limit: limit, offset: offset)

        expect(CustomClass).not_to have_received(:new)
      end

      it 'returns empty array' do
        expect(CustomClass.load(limit: limit, offset: offset)).to eq([])
      end
    end
  end
end
