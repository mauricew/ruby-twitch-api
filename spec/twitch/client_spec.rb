# frozen_string_literal: true

RSpec.describe Twitch::Client, :vcr do
  subject(:client) do
    Twitch::Client.new(
      client_id: client_id,
      client_secret: client_secret,
      ## Optional parameters below
      access_token: access_token,
      refresh_token: refresh_token,
      token_type: token_type,
      scopes: scopes,
      redirect_uri: redirect_uri
    )
  end

  let(:client_id) { ENV['TWITCH_CLIENT_ID'] }
  let(:client_secret) { ENV['TWITCH_CLIENT_SECRET'] }
  let(:access_token) { ENV['TWITCH_ACCESS_TOKEN'] }
  let(:outdated_access_token) { '9y7bf00r4fof71czggal1e2wlo50q3' }
  let(:refresh_token) { ENV['TWITCH_REFRESH_TOKEN'] }
  let(:token_type) { :application }
  let(:scopes) { [] }
  let(:redirect_uri) { 'http://localhost' }

  describe '#get_bits_leaderboard' do
    subject { super().get_bits_leaderboard.body }

    let(:scopes) { %w[bits:read] }

    context 'when `token_type` is `user`' do
      let(:token_type) { :user }

      let(:expected_result) do
        { 'data' => [], 'date_range' => { 'ended_at' => '', 'started_at' => '' }, 'total' => 0 }
      end

      context 'with `access_token`' do
        context 'when `access_token` is actual' do
          it { is_expected.to eq expected_result }
        end

        context 'when `access_token` is outdated' do
          let(:access_token) { outdated_access_token }

          context 'with `refresh_token`' do
            it { is_expected.to eq expected_result }
          end

          context 'without `refresh_token`' do
            let(:refresh_token) { nil }

            it { expect { subject }.to raise_error TwitchOAuth2::Error, 'missing refresh token' }
          end
        end
      end

      context 'without tokens' do
        let(:access_token) { nil }
        let(:refresh_token) { nil }

        let(:redirect_params) do
          URI.encode_www_form_component URI.encode_www_form(
            client_id: client_id,
            redirect_uri: redirect_uri,
            response_type: :code,
            scope: scopes.join(' ')
          )
        end

        let(:expected_instructions) do
          <<~TEXT
            1. Open URL in your browser:
            	https://www.twitch.tv/login?client_id=#{client_id}&redirect_params=#{redirect_params}
            2. Login to Twitch.
            3. Copy the `code` parameter from redirected URL.
            4. Insert below:
          TEXT
        end

        before do
          unless VCR.current_cassette.recording?
            allow($stdout).to receive(:puts).with(expected_instructions)
            allow($stdin).to receive(:gets).and_return 'any_code'
          end
        end

        ## Without cassettes it will require authentication in CLI
        it { is_expected.to eq expected_result }
      end
    end

    context 'when `token_type` is `application`' do
      let(:token_type) { :application }

      context 'without tokens' do
        let(:access_token) { nil }
        let(:refresh_token) { nil }

        it { expect { subject }.to raise_error Twitch::APIError, 'Missing User OAUTH Token' }
      end
    end
  end

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
      test_user_login = 'GemsFireplace'

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
