# frozen_string_literal: true

require 'rails_helper'

describe 'Items API [GET]' do
  describe 'GET /items' do
    describe 'When the records exist' do
      before :each do
        @merchant = create(:merchant)
        @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 75_000, merchant_id: @merchant.id)
        @item2 = Item.create!(name: 'name2', description: 'desc2', unit_price: 85_000, merchant_id: @merchant.id)
      end

      it 'returns a successful response' do
        get '/api/v1/items'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
      end

      it 'returns a status code 200' do
        get '/api/v1/items'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
      end

      it 'returns all items' do
        get '/api/v1/items'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data].count).to eq(2)
        expect(items[:data].first).to have_key(:id)
        expect(items[:data].first).to have_key(:type)
        expect(items[:data].first).to have_key(:attributes)
        expect(items[:data].class).to be Array
        expect(items[:data].first.class).to be Hash

        expect(items[:data].first[:attributes]).to have_key(:name)
        expect(items[:data].first[:attributes]).to have_key(:description)
        expect(items[:data].first[:attributes]).to have_key(:unit_price)
        expect(items[:data].first[:attributes]).to have_key(:merchant_id)

        expect(items[:data][0][:attributes][:name].class).to be String
        expect(items[:data][0][:attributes][:description].class).to be String
        expect(items[:data][0][:attributes][:unit_price].class).to be Float
        expect(items[:data][0][:attributes][:merchant_id].class).to be Integer
      end
    end
  end

  describe 'GET /items/:id' do
    describe 'When the records exist' do
      before :each do
        @merchant = create(:merchant)
        @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 75_000, merchant_id: @merchant.id)
        @item2 = Item.create!(name: 'name2', description: 'desc2', unit_price: 85_000, merchant_id: @merchant.id)
      end

      it 'returns a successful response' do
        get "/api/v1/items/#{@item1.id}"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
      end

      it 'returns a status code 200' do
        get "/api/v1/items/#{@item1.id}"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
      end

      it 'returns an item' do
        get "/api/v1/items/#{@item1.id}"

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item.class).to be Hash
        expect(item).to have_key(:data)
        expect(item[:data].class).to be Hash

        expect(item[:data]).to have_key(:id)
        expect(item[:data]).to have_key(:type)
        expect(item[:data]).to have_key(:attributes)

        expect(item[:data][:id].class).to be String
        expect(item[:data][:type].class).to be String
        expect(item[:data][:attributes].class).to be Hash

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes]).to have_key(:merchant_id)

        expect(item[:data][:attributes][:name].class).to be String
        expect(item[:data][:attributes][:description].class).to be String
        expect(item[:data][:attributes][:unit_price].class).to be Float
        expect(item[:data][:attributes][:merchant_id].class).to be Integer
      end
    end

    describe 'When the record DNE' do
      it 'returns status code 404' do
        get '/api/v1/items/4'

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get '/api/v1/items/4'

        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'GET /items/:item_id/merchant' do
    describe 'When the records exist' do
      before :each do
        @merchant = create(:merchant)
        @item = Item.create!(name: 'name1', description: 'desc1', unit_price: 75_000, merchant_id: @merchant.id)
      end

      it 'returns a successful response' do
        get "/api/v1/items/#{@item.id}/merchant"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
      end

      it 'returns a status code 200' do
        get "/api/v1/items/#{@item.id}/merchant"

        JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
      end
    end

    describe 'When the record DNE' do
      it 'returns status code 404' do
        get '/api/v1/items/4/merchant'

        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        get '/api/v1/items/4'

        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'GET /items/find_all?name=' do
    before :each do
      @merchant = create(:merchant)
      @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 99.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'name2', description: 'desc1', unit_price: 37.99, merchant_id: @merchant.id)
      @item3 = Item.create!(name: 'name3', description: 'desc1', unit_price: 84.99, merchant_id: @merchant.id)
      @item4 = Item.create!(name: 'name4', description: 'desc1', unit_price: 79.99, merchant_id: @merchant.id)
    end

    describe 'When the records exist' do
      it 'returns a status code 200' do
        get '/api/v1/items/find_all?name=name'

        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end

      it 'has readable attributes' do
        get '/api/v1/items/find_all?name=name'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data].count).to eq(4)
        expect(items[:data].first).to have_key(:id)
        expect(items[:data].first).to have_key(:type)
        expect(items[:data].first).to have_key(:attributes)
        expect(items[:data].class).to be Array
        expect(items[:data].first.class).to be Hash

        expect(items[:data].first[:attributes]).to have_key(:name)
        expect(items[:data].first[:attributes]).to have_key(:description)
        expect(items[:data].first[:attributes]).to have_key(:unit_price)
        expect(items[:data].first[:attributes]).to have_key(:merchant_id)

        expect(items[:data][0][:attributes][:name].class).to be String
        expect(items[:data][0][:attributes][:description].class).to be String
        expect(items[:data][0][:attributes][:unit_price].class).to be Float
        expect(items[:data][0][:attributes][:merchant_id].class).to be Integer
      end
    end

    describe 'When a name is provided but does not partially match anything in the DB' do
      it 'returns data as a an empty hash' do
        get '/api/v1/items/find_all?name=nam5'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq([])
      end

      it 'returns status 404' do
        get '/api/v1/items/find_all?name=nam5'
        # binding.pry
        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(404)
      end
    end

    describe 'When no name is provided' do
      it 'returns an invalid search' do
        get '/api/v1/items/find_all?name='

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq('Invalid Search')
      end

      it 'returns status 400' do
        get '/api/v1/items/find_all?name='

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)
      end
    end
  end

  describe ' GET /items/find_all?min_price = ' do
    before :each do
      @merchant = create(:merchant)
      @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 99.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'name2', description: 'desc1', unit_price: 37.99, merchant_id: @merchant.id)
      @item3 = Item.create!(name: 'name3', description: 'desc1', unit_price: 84.99, merchant_id: @merchant.id)
      @item4 = Item.create!(name: 'name4', description: 'desc1', unit_price: 79.99, merchant_id: @merchant.id)
    end

    describe 'When the record exists' do
      describe 'and greater than 0' do
        it 'it returns a code 200' do
          get '/api/v1/items/find_all?min_price=50'

          expect(response).to be_successful
          expect(response).to have_http_status(200)
        end

        it 'has readable attributes' do
          get '/api/v1/items/find_all?min_price=50'

          items = JSON.parse(response.body, symbolize_names: true)

          expect(items.class).to be Hash
          expect(items).to have_key(:data)
          expect(items[:data].count).to eq(3)
          expect(items[:data].first).to have_key(:id)
          expect(items[:data].first).to have_key(:type)
          expect(items[:data].first).to have_key(:attributes)
          expect(items[:data].class).to be Array
          expect(items[:data].first.class).to be Hash
        end
      end

      describe 'when less than 0' do
        it 'it returns a code 400' do
          get '/api/v1/items/find_all?min_price=-50'

          expect(response).to have_http_status(400)
        end
      end
    end

    describe 'When the record DNE' do
      it 'returns a blank data array' do
        get '/api/v1/items/find_all?min_price=50000'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq([])
      end
    end

    describe 'When the param is blank' do
      it 'return invalid search' do
        get '/api/v1/items/find_all?min_price='

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq('Invalid Search')
      end
    end
  end

  describe ' GET /items/find_all?max_price= ' do
    before :each do
      @merchant = create(:merchant)
      @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 99.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'name2', description: 'desc1', unit_price: 37.99, merchant_id: @merchant.id)
      @item3 = Item.create!(name: 'name3', description: 'desc1', unit_price: 84.99, merchant_id: @merchant.id)
      @item4 = Item.create!(name: 'name4', description: 'desc1', unit_price: 79.99, merchant_id: @merchant.id)
    end

    describe 'When the record exists' do
      describe 'and greater than 0' do
        it 'it returns a code 200' do
          get '/api/v1/items/find_all?max_price=50'

          expect(response).to have_http_status(200)
        end

        it 'has readable attributes' do
          get '/api/v1/items/find_all?max_price=50'

          items = JSON.parse(response.body, symbolize_names: true)
          # binding.pry
          expect(items.class).to be Hash
          expect(items).to have_key(:data)
          expect(items[:data].count).to eq(1)
          expect(items[:data].first).to have_key(:id)
          expect(items[:data].first).to have_key(:type)
          expect(items[:data].first).to have_key(:attributes)
          expect(items[:data].class).to be Array
          expect(items[:data].first.class).to be Hash
        end
      end

      describe 'when less than 0' do
        it 'it returns a code 400' do
          get '/api/v1/items/find_all?max_price=-50'

          expect(response).to have_http_status(400)
        end
      end
    end

    describe 'When the record DNE' do
      it 'returns a blank data array' do
        get '/api/v1/items/find_all?max_price=1'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq([])
      end
    end

    describe 'When the param is blank' do
      it 'return invalid search' do
        get '/api/v1/items/find_all?max_price='

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq('Invalid Search')
      end
    end
  end

  describe 'GET /items/find?name=' do
    before :each do
      @merchant = create(:merchant)
      @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 99.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'name2', description: 'desc1', unit_price: 37.99, merchant_id: @merchant.id)
      @item3 = Item.create!(name: 'name3', description: 'desc1', unit_price: 84.99, merchant_id: @merchant.id)
      @item4 = Item.create!(name: 'name4', description: 'desc1', unit_price: 79.99, merchant_id: @merchant.id)
    end

    describe 'When the record exists' do
      it 'returns a status code 200' do
        get '/api/v1/items/find?name=name'

        expect(response).to be_successful
        expect(response).to have_http_status(200)
      end

      it 'has readable attributes' do
        get '/api/v1/items/find?name=name'

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item.class).to be Hash
        expect(item).to have_key(:data)
        expect(item[:data]).to have_key(:id)
        expect(item[:data]).to have_key(:type)
        expect(item[:data]).to have_key(:attributes)
        expect(item[:data].class).to be Hash
      end
    end

    describe 'When a name is provided but does not partially match anything in the DB' do
      it 'returns data as a an empty hash' do
        get '/api/v1/items/find?name=nam5'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq({})
      end

      it 'returns status 404' do
        get '/api/v1/items/find?name=nam5'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(404)
      end
    end
  end

  describe ' GET /items/find?min_price= ' do
    before :each do
      @merchant = create(:merchant)
      @item1 = Item.create!(name: 'nem1', description: 'desc1', unit_price: 99.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'name2', description: 'desc1', unit_price: 37.99, merchant_id: @merchant.id)
      @item3 = Item.create!(name: 'nae3', description: 'desc1', unit_price: 84.99, merchant_id: @merchant.id)
      @item4 = Item.create!(name: 'name4', description: 'desc1', unit_price: 79.99, merchant_id: @merchant.id)
    end

    describe 'When the record exists' do
      describe 'and greater than 0' do
        it 'it returns a code 200' do
          get '/api/v1/items/find?min_price=50'

          expect(response).to be_successful
          expect(response).to have_http_status(200)
        end

        it 'has readable attributes' do
          get '/api/v1/items/find?min_price=50'

          item = JSON.parse(response.body, symbolize_names: true)

          expect(item.class).to be Hash
          expect(item).to have_key(:data)
          expect(item[:data]).to have_key(:id)
          expect(item[:data]).to have_key(:type)
          expect(item[:data]).to have_key(:attributes)
          expect(item[:data].class).to be Hash
        end
      end

      describe 'when less than 0' do
        it 'it returns a code 400' do
          get '/api/v1/items/find?min_price=-50'

          expect(response).to have_http_status(400)
        end
      end
    end

    describe 'When the param is blank' do
      it 'return invalid search' do
        get '/api/v1/items/find?min_price='

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq('Invalid Search')
      end
    end
  end

  describe ' GET /items/find?max_price= ' do
    before :each do
      @merchant = create(:merchant)
      @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 99.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'name2', description: 'desc1', unit_price: 37.99, merchant_id: @merchant.id)
      @item3 = Item.create!(name: 'name3', description: 'desc1', unit_price: 84.99, merchant_id: @merchant.id)
      @item4 = Item.create!(name: 'name4', description: 'desc1', unit_price: 79.99, merchant_id: @merchant.id)
    end

    describe 'When the record exists' do
      describe 'and greater than 0' do
        it 'it returns a code 200' do
          get '/api/v1/items/find?max_price=50'

          expect(response).to have_http_status(200)
        end

        it 'has readable attributes' do
          get '/api/v1/items/find?max_price=50'

          item = JSON.parse(response.body, symbolize_names: true)
          # binding.pry
          expect(item.class).to be Hash
          expect(item).to have_key(:data)
          expect(item[:data]).to have_key(:id)
          expect(item[:data]).to have_key(:type)
          expect(item[:data]).to have_key(:attributes)
          expect(item[:data].class).to be Hash
        end
      end

      describe 'when less than 0' do
        it 'it returns a code 400' do
          get '/api/v1/items/find?max_price=-50'

          expect(response).to have_http_status(400)
        end
      end
    end

    describe 'When the record DNE' do
      it 'returns a blank data array' do
        get '/api/v1/items/find?max_price=1'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq({})
      end
    end

    describe 'When the param is blank' do
      it 'return invalid search' do
        get '/api/v1/items/find?max_price='

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq('Invalid Search')
      end
    end
  end

  describe ' GET /items/find_all?min_price=num&max_price=nam' do
    before :each do
      @merchant = create(:merchant)
      @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 99.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'name2', description: 'desc1', unit_price: 37.99, merchant_id: @merchant.id)
      @item3 = Item.create!(name: 'name3', description: 'desc1', unit_price: 84.99, merchant_id: @merchant.id)
      @item4 = Item.create!(name: 'name4', description: 'desc1', unit_price: 79.99, merchant_id: @merchant.id)
    end

    describe 'When the record exists' do
      describe 'and greater than 0 for each param' do
        it 'it returns a code 200' do
          get '/api/v1/items/find_all?min_price=50&max_price=90'

          expect(response).to be_successful
          expect(response).to have_http_status(200)
        end

        it 'has readable attributes' do
          get '/api/v1/items/find_all?min_price=50&max_price=90'

          items = JSON.parse(response.body, symbolize_names: true)
          # binding.pry
          expect(items.class).to be Hash
          expect(items).to have_key(:data)
          expect(items[:data].count).to eq(2)
          expect(items[:data].first).to have_key(:id)
          expect(items[:data].first).to have_key(:type)
          expect(items[:data].first).to have_key(:attributes)
          expect(items[:data].class).to be Array
          expect(items[:data].first.class).to be Hash
        end
      end
    end

    describe "When the record does not exits" do
      it 'returns Invalid Search' do
        get '/api/v1/items/find_all?max_price=1&min_price=0'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq('Invalid Search')
      end
    end

    describe "if min > max" do
      it 'returns a blank array' do
        get '/api/v1/items/find_all?max_price=10&min_price=60'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq([])
      end
    end
  end

  describe ' GET /items/find?min_price=num&max_price=nam' do
    before :each do
      @merchant = create(:merchant)
      @item1 = Item.create!(name: 'name1', description: 'desc1', unit_price: 99.99, merchant_id: @merchant.id)
      @item2 = Item.create!(name: 'name2', description: 'desc1', unit_price: 37.99, merchant_id: @merchant.id)
      @item3 = Item.create!(name: 'name3', description: 'desc1', unit_price: 84.99, merchant_id: @merchant.id)
      @item4 = Item.create!(name: 'name4', description: 'desc1', unit_price: 79.99, merchant_id: @merchant.id)
    end

    describe 'When the record exists' do
      describe 'and greater than 0 for each param' do
        it 'it returns a code 200' do
          get '/api/v1/items/find?min_price=50&max_price=90'

          expect(response).to be_successful
          expect(response).to have_http_status(200)
        end

        it 'has readable attributes' do
          get '/api/v1/items/find?min_price=50&max_price=90'

          item = JSON.parse(response.body, symbolize_names: true)
          # binding.pry
          expect(item.class).to be Hash
          expect(item).to have_key(:data)
          expect(item[:data]).to have_key(:id)
          expect(item[:data]).to have_key(:type)
          expect(item[:data]).to have_key(:attributes)
          expect(item[:data].class).to be Hash
        end
      end
    end

    describe "When the record does not exits" do
      it 'returns Invalid Search' do
        get '/api/v1/items/find?max_price=1&min_price=0'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq('Invalid Search')
        expect(response).to have_http_status(400)
      end
    end

    describe "if min > max" do
      it 'returns a blank array' do
        get '/api/v1/items/find?max_price=10&min_price=60'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items.class).to be Hash
        expect(items).to have_key(:data)
        expect(items[:data]).to eq({})
        expect(response).to have_http_status(400)
      end
    end
  end
end
