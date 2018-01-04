RSpec.describe Twitch::Client do
  before(:all) do
    @api_key = ENV["TWITCH_CLIENT_ID"]

    raise "API key is required for tests" if @api_key.to_s.empty?

    @client = Twitch::Client.new(client_id: @api_key)
  end

  describe '#get_clips' do
    it 'will return information about a clip' do
      VCR.use_cassette('get_clips_OEHHL') do
        broadcaster_id_greekgodx = 15310631

        res = @client.get_clips({id: 'ObliqueEncouragingHumanHumbleLife'})

        expect(res.data).to_not be_empty
        expect(res.data.first.broadcaster_id).to eq(broadcaster_id_greekgodx.to_s)
      end
    end
  end

  describe '#get_streams' do
    it 'will return the 20 most concurrently watched streams by default' do
      VCR.use_cassette('get_streams_default') do
        res = @client.get_streams({})

        expect(res.data.length).to eq(20)
      end
    end
    it 'can retrieve a single live stream by username' do
      test_user_login = 'disguisedtoasths'

      VCR.use_cassette('get_streams_disguisedtoasths') do
        res = @client.get_streams({user_login: test_user_login})

        expect(res.data).to_not be_empty
        expect(res.data[0].viewer_count).to be_an(Integer)
      end
    end
  end

  describe '#get_users' do
    it 'can retrive a user by id' do
      test_user_id = 18587270

      VCR.use_cassette('get_users_day9tv') do
        res = @client.get_users({id: test_user_id})

        expect(res.data).to_not be_empty
        expect(res.data[0].login).to eq('day9tv')
      end
    end

    it 'should get the information of a user your are acting on behalf of'
  end

  describe '#get_games' do
    it 'can retrieve multiple games by name' do
      VCR.use_cassette('get_games_hots_smo') do
        res = @client.get_games({name: ["Heroes of the Storm", "Super Mario Odyssey"]})

        expect(res.data.length).to eq(2)
      end
    end
  end

  describe '#get_videos' do
    it 'can retrieve videos for a user' do
      test_video_user_id = 9846758

      VCR.use_cassette('get_videos_user_vgboootcamp') do
        res = @client.get_videos({user_id: test_video_user_id})

        expect(res.data).to_not be_empty
        expect(res.pagination['cursor']).to_not be_nil
      end
    end
  end
    
end