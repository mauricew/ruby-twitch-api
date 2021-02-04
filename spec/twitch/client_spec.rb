# frozen_string_literal: true

RSpec.describe Twitch::Client, :vcr do
  subject(:client) do
    described_class.new(
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
    subject(:body) { client.get_bits_leaderboard.body }

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

            it { expect { body }.to raise_error TwitchOAuth2::Error, 'missing refresh token' }
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

        let(:expected_login_url) do
          "https://www.twitch.tv/login?client_id=#{client_id}&redirect_params=#{redirect_params}"
        end

        it do
          expect { body }.to raise_error an_instance_of(TwitchOAuth2::Error)
            .and having_attributes(
              message: 'Use `error.metadata[:link]` for getting new tokens',
              metadata: { link: expected_login_url }
            )
        end
      end
    end

    context 'when `token_type` is `application`' do
      let(:token_type) { :application }

      context 'without tokens' do
        let(:access_token) { nil }
        let(:refresh_token) { nil }

        it { expect { body }.to raise_error Twitch::APIError, 'Missing User OAUTH Token' }
      end
    end
  end

  describe '#get_clips' do
    subject { client.get_clips(id: 'ObliqueEncouragingHumanHumbleLife').data }

    let(:broadcaster_id_greekgodx) { 15_310_631 }

    it { is_expected.not_to be_empty }

    describe '#broadcaster_id' do
      subject { super().first.broadcaster_id }

      it { is_expected.to eq broadcaster_id_greekgodx.to_s }
    end
  end

  describe '#get_streams' do
    subject { client.get_streams(**kwargs).data }

    context 'with empty kwargs' do
      let(:kwargs) { {} }

      describe 'data length' do
        subject { super().length }

        it { is_expected.to eq(20) }
      end
    end

    context 'with username' do
      let(:kwargs) { { user_login: 'SunsetClub' } }

      it { is_expected.not_to be_empty }

      describe 'viewer_count' do
        subject { super().first.viewer_count }

        it { is_expected.to be_an(Integer) }
      end
    end
  end

  describe '#get_users' do
    subject { client.get_users(id: 18_587_270).data }

    it { is_expected.not_to be_empty }

    describe 'login' do
      subject { super().first.login }

      it { is_expected.to eq 'day9tv' }
    end
  end

  describe '#get_games' do
    subject { client.get_games(name: games_names) }

    let(:games_names) { ['Heroes of the Storm', 'Super Mario Odyssey'] }

    describe 'data length' do
      subject { super().data.length }

      it { is_expected.to eq games_names.size }
    end
  end

  describe '#get_top_games' do
    subject { client.get_top_games(first: limit) }

    let(:limit) { 5 }

    describe 'data length' do
      subject { super().data.length }

      it { is_expected.to eq limit }
    end
  end

  describe '#get_videos' do
    subject { client.get_videos(user_id: 9_846_758) }

    describe 'data' do
      subject { super().data }

      it { is_expected.not_to be_empty }
    end

    describe 'pagination cursor' do
      subject { super().pagination['cursor'] }

      it { is_expected.not_to be_nil }
    end
  end
end
