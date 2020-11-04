# frozen_string_literal: true

RSpec.describe Twitch::Client, :vcr do
  subject(:client) do
    Twitch::Client.new(
      client_id: client_id,
      client_secret: client_secret
    )
  end

  let(:client_id) { ENV['TWITCH_CLIENT_ID'] }
  let(:client_secret) { ENV['TWITCH_CLIENT_SECRET'] }

  describe '#get_clips' do
    it 'will return information about a clip' do
      broadcaster_id_greekgodx = 15_310_631

      res = client.get_clips(id: 'ObliqueEncouragingHumanHumbleLife')

      expect(res.data).to_not be_empty
      expect(res.data.first.broadcaster_id)
        .to eq(broadcaster_id_greekgodx.to_s)
    end
  end

  describe '#get_streams' do
    it 'will return the 20 most concurrently watched streams by default' do
      res = client.get_streams({})

      # Expecting the site to have regular use
      expect(res.data.length).to eq(20)
    end

    it 'can retrieve a single live stream by username' do
      test_user_login = 'AlexWayfer'

      res = client.get_streams(user_login: test_user_login)

      expect(res.data).to_not be_empty
      expect(res.data[0].viewer_count).to be_an(Integer)
    end
  end

  describe '#get_users' do
    it 'can retrieve a user by id' do
      test_user_id = 18_587_270

      res = client.get_users(id: test_user_id)

      expect(res.data).to_not be_empty
      expect(res.data[0].login).to eq('day9tv')
    end

    it 'should get the information of a user your are acting on behalf of'
  end

  describe '#get_games' do
    it 'can retrieve multiple games by name' do
      res = client.get_games(
        name: ['Heroes of the Storm', 'Super Mario Odyssey']
      )

      expect(res.data.length).to eq(2)
    end
  end

  describe '#get_top_games' do
    it 'can return the top games by current viewership' do
      res = client.get_top_games(first: 5)

      # Expecting the site to have regular use
      expect(res.data.length).to eq(5)
    end
  end

  describe '#get_videos' do
    it 'can retrieve videos for a user' do
      test_video_user_id = 9_846_758

      res = client.get_videos(user_id: test_video_user_id)

      expect(res.data).to_not be_empty
      expect(res.pagination['cursor']).to_not be_nil
    end
  end
end
