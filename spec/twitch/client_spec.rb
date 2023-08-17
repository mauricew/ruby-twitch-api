# frozen_string_literal: true

RSpec.describe Twitch::Client, :vcr do
  subject(:client) do
    described_class.new(
      tokens: TwitchOAuth2::Tokens.new(
        client: {
          client_id: client_id,
          client_secret: client_secret,
          redirect_uri: redirect_uri
        },
        access_token: access_token,
        refresh_token: refresh_token,
        token_type: token_type,
        scopes: scopes
      )
    )
  end

  let(:client_id) { ENV.fetch('TWITCH_CLIENT_ID') }
  let(:client_secret) { ENV.fetch('TWITCH_CLIENT_SECRET') }

  let(:access_token) do
    case token_type
    when :user
      ENV.fetch('TWITCH_ACCESS_TOKEN')
    when :application
      ENV.fetch('TWITCH_APPLICATION_ACCESS_TOKEN')
    else
      raise "Unknown token type: #{token_type.inspect}"
    end
  end

  let(:outdated_access_token) { '9y7bf00r4fof71czggal1e2wlo50q3' }
  let(:refresh_token) { ENV.fetch('TWITCH_REFRESH_TOKEN') }
  let(:token_type) { :application }
  let(:scopes) { [] }
  let(:redirect_uri) { 'http://localhost' }

  let(:uuid_string) do
    a_string_matching(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i)
  end
  let(:url_string) do
    a_string_matching(%r{^https://[\w\-./]+$}i)
  end
  let(:hex_color_string) do
    a_string_matching(/^#[0-9a-f]{6}$/i)
  end

  describe '#get_bits_leaderboard' do
    def make_request
      client.get_bits_leaderboard.body
    end

    subject(:body) { make_request }

    let(:scopes) { %w[bits:read] }

    let(:expected_result) do
      { 'data' => [], 'date_range' => { 'ended_at' => '', 'started_at' => '' }, 'total' => 0 }
    end

    context 'when `token_type` is `user`' do
      let(:token_type) { :user }

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

        context 'when `access_token` was actual, but became outdated' do
          before do
            make_request
            client.class::CONNECTION.headers['Authorization'] = "Bearer #{outdated_access_token}"
          end

          context 'with `refresh_token`' do
            it { is_expected.to eq expected_result }
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
          expect { body }.to raise_error an_instance_of(TwitchOAuth2::AuthorizeError)
            .and having_attributes(
              message: 'Direct user to `error.link` and assign `code`',
              link: expected_login_url
            )
        end
      end
    end

    ## This API method requires User Access Token
    context 'when `token_type` is `application`' do
      let(:token_type) { :application }

      context 'with correct client credentials' do
        context 'with tokens' do
          it { expect { body }.to raise_error Twitch::APIError, 'Missing User OAUTH Token' }
        end
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
    subject(:data) { client.get_users(id: user_id).data }

    let(:user_id) { 18_587_270 }

    let(:expected_result) do
      have_attributes(
        id: user_id.to_s,
        login: 'day9tv',
        display_name: 'Day9tv',
        created_at: Time.new(2010, 12, 9, 5, 50, 55, '+00:00')
      )
    end

    context 'when `token_type` is `application`' do
      let(:token_type) { :application }

      context 'with correct client credentials' do
        context 'with tokens' do
          it { is_expected.to contain_exactly expected_result }
        end

        context 'without tokens' do
          let(:access_token) { nil }
          let(:refresh_token) { nil }

          it { is_expected.to contain_exactly expected_result }
        end
      end

      context 'with incorrect client credentials' do
        let(:client_id) { nil }
        let(:client_secret) { nil }

        context 'with tokens' do
          it { expect { data }.to raise_error Twitch::APIError, 'Client ID is missing' }
        end

        context 'without tokens' do
          let(:access_token) { nil }
          let(:refresh_token) { nil }

          it { expect { data }.to raise_error TwitchOAuth2::Error, 'missing client id' }
        end
      end
    end
  end

  describe '#get_users_follows' do
    subject { client.get_users_follows(from_id: from_id, first: 100).data }

    let(:from_id) { '117474239' }
    let(:from_name) { 'AlexWayfer' }

    let(:expected_elements) do
      [
        have_attributes(
          from_id: from_id,
          from_name: from_name,
          to_id: '519237924',
          to_name: 'azhomnir',
          followed_at: Time.new(2020, 4, 23, 19, 18, 25, '+00:00')
        ),
        have_attributes(
          from_id: from_id,
          from_name: from_name,
          to_id: '238339665',
          to_name: 'pierr0t777',
          followed_at: Time.new(2021, 8, 5, 19, 16, 39, '+00:00')
        )
      ]
    end

    it { is_expected.to include(*expected_elements) }
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

  describe '#get_channels' do
    subject(:request) { client.get_channels(options) }

    context 'without options' do
      let(:options) { {} }

      context 'when token type is application' do
        let(:token_type) { :application }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing required parameter "broadcaster_id"'
          )
        end
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing required parameter "broadcaster_id"'
          )
        end
      end
    end

    context 'with options' do
      let(:options) { { broadcaster_id: broadcaster_id } }

      context 'when broadcaster ID is single value' do
        ## `StreamAssistantBot`
        let(:broadcaster_id) { '277558749' }

        describe 'data' do
          subject { super().data }

          let(:expected_attributes) do
            {
              broadcaster_id: broadcaster_id,
              broadcaster_login: 'streamassistantbot',
              broadcaster_name: 'StreamAssistantBot',
              broadcaster_language: a_string_matching(/^([a-z]{2}|other)$/),
              game_id: a_string_matching(/^\d+$/),
              game_name: a_kind_of(String),
              title: a_kind_of(String),
              delay: 0
            }
          end

          it { is_expected.to contain_exactly(have_attributes(expected_attributes)) }
        end
      end

      context 'when broadcaster ID is an Array of values' do
        ## `StreamAssistantBot`, `AlexWayfer`
        let(:broadcaster_id) { %w[277558749 117474239] }

        describe 'data' do
          subject { super().data }

          let(:expected_elements) do
            [
              have_attributes(
                broadcaster_id: broadcaster_id[0],
                broadcaster_login: 'streamassistantbot',
                broadcaster_name: 'StreamAssistantBot'
              ),
              have_attributes(
                broadcaster_id: broadcaster_id[1],
                broadcaster_login: 'alexwayfer',
                broadcaster_name: 'AlexWayfer'
              )
            ]
          end

          it { is_expected.to match_array(expected_elements) }
        end
      end
    end
  end

  describe '#search_channels' do
    subject(:request) { client.search_channels(options) }

    context 'without options' do
      let(:options) { {} }

      context 'when token type is application' do
        let(:token_type) { :application }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing required parameter "query"'
          )
        end
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing required parameter "query"'
          )
        end
      end
    end

    context 'with options' do
      let(:options) { { query: 'angel of death' } }

      describe 'data' do
        subject { super().data }

        let(:expected_attributes) do
          {
            id: a_string_matching(/^\d+$/),
            broadcaster_login: a_string_matching(/^\w{3,}$/),
            display_name: an_instance_of(String),
            broadcaster_language: a_string_matching(/^([a-z]{2}|other)$/),
            game_id: a_string_matching(/^\d+$/),
            game_name: an_instance_of(String),
            title: an_instance_of(String)
          }
        end

        it { is_expected.to include(an_object_having_attributes(expected_attributes)) }
      end
    end
  end

  describe '#modify_channel' do
    subject(:request) do
      client.modify_channel(
        ## `StreamAssistantBot`
        broadcaster_id: '277558749',
        game_id: new_game_id,
        title: 'Test'
      )
    end

    let(:token_type) { :user }

    context 'when everything is OK' do
      ## `Science & Technology`
      let(:new_game_id) { '509670' }

      it { is_expected.to be true }
    end

    context 'when game ID is incorrect' do
      let(:new_game_id) { 'abc' }

      specify do
        expect { request }.to raise_error(Twitch::APIError, 'The ID in game_id is not valid.')
      end
    end
  end

  describe '#get_moderators' do
    subject(:request) { client.get_moderators(options) }

    context 'without options' do
      let(:options) { {} }

      context 'when token type is application' do
        let(:token_type) { :application }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'The broadcaster_id query parameter is required.'
          )
        end
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'The broadcaster_id query parameter is required.'
          )
        end
      end
    end

    context 'with options' do
      let(:options) { { broadcaster_id: broadcaster_id } }

      context 'when broadcaster ID is foreign channel' do
        ## LIRIK
        let(:broadcaster_id) { '23161357' }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, <<~MESSAGE.chomp
              The ID in broadcaster_id must match the user ID found in the request's OAuth token.
            MESSAGE
          )
        end
      end

      context 'when broadcaster ID is your own' do
        ## `StreamAssistantBot`
        let(:broadcaster_id) { '277558749' }

        describe 'data' do
          subject { super().data }

          let(:expected_elements) do
            [
              have_attributes(
                user_id: '117474239',
                user_login: 'alexwayfer',
                user_name: 'AlexWayfer'
              )
            ]
          end

          it { is_expected.to match_array(expected_elements) }
        end
      end
    end
  end

  describe '#get_user_active_extensions' do
    subject(:request) { client.get_user_active_extensions(options) }

    context 'without options' do
      let(:options) { {} }

      context 'when token type is application' do
        let(:token_type) { :application }

        specify do
          expect { p request }.to raise_error(
            Twitch::APIError,
            'The user_id query parameter is required if you specify an app access token.'
          )
        end
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        it 'returns extensions for the authentificated user' do
          expect { request }.not_to raise_error
        end
      end
    end

    context 'with options' do
      let(:options) { { user_id: user_id } }

      ## `StreamAssistantBot`
      let(:user_id) { '277558749' }

      context 'when token type is application' do
        let(:token_type) { :application }

        describe 'data' do
          subject { super().data }

          let(:expected_extension_attributes) do
            {
              id: a_string_matching(/^\w+$/),
              active: true,
              version: a_string_matching(/^\d+(\.\d+)*$/),
              name: an_instance_of(String)
            }
          end

          let(:expected_attributes) do
            {
              panel: matching(
                '1' => an_object_having_attributes(expected_extension_attributes),
                '2' => an_object_having_attributes(active: false),
                '3' => an_object_having_attributes(active: false)
              ),
              overlay: matching(
                '1' => an_object_having_attributes(expected_extension_attributes)
              ),
              component: matching(
                '1' => an_object_having_attributes(active: false),
                '2' => an_object_having_attributes(active: false)
              )
            }
          end

          it { is_expected.to have_attributes(expected_attributes) }
        end
      end
    end
  end

  describe '#get_custom_reward' do
    subject(:request) { client.get_custom_reward(options) }

    context 'without options' do
      let(:options) { {} }

      context 'when token type is application' do
        let(:token_type) { :application }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing required parameter "broadcaster_id"'
          )
        end
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing required parameter "broadcaster_id"'
          )
        end
      end
    end

    context 'with options' do
      let(:options) { { broadcaster_id: broadcaster_id } }

      ## `AlexWayfer`
      ## It has to be partner or affiliate.
      let(:broadcaster_id) { '117474239' }

      context 'when token type is application' do
        let(:token_type) { :application }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing User OAUTH Token'
          )
        end
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        describe 'data' do
          subject { super().data }

          let(:expected_reward_attributes) do
            {
              broadcaster_id: broadcaster_id,
              broadcaster_login: a_string_matching(/^\w{3,}$/),
              broadcaster_name: an_instance_of(String),
              id: uuid_string,
              title: an_instance_of(String),
              prompt: an_instance_of(String),
              cost: an_instance_of(Integer),
              image: an_object_having_attributes(
                url_1x: url_string,
                url_2x: url_string,
                url_4x: url_string
              ),
              default_image: an_object_having_attributes(
                url_1x: url_string,
                url_2x: url_string,
                url_4x: url_string
              ),
              background_color: hex_color_string,
              is_enabled: a_boolean,
              is_user_input_required: a_boolean,
              max_per_stream_setting: matching(
                'is_enabled' => a_boolean,
                'max_per_stream' => an_instance_of(Integer)
              ),
              max_per_user_per_stream_setting: matching(
                'is_enabled' => a_boolean,
                'max_per_user_per_stream' => an_instance_of(Integer)
              ),
              global_cooldown_setting: matching(
                'is_enabled' => a_boolean,
                'global_cooldown_seconds' => an_instance_of(Integer)
              ),
              is_paused: a_boolean,
              is_in_stock: a_boolean,
              should_redemptions_skip_request_queue: a_boolean,
              redemptions_redeemed_current_stream: an_instance_of(Integer).or(be_nil),
              cooldown_expires_at: nil
            }
          end

          it { is_expected.to include an_object_having_attributes(expected_reward_attributes) }
        end
      end
    end
  end

  describe '#search_categories' do
    subject(:request) { client.search_categories(options) }

    context 'without options' do
      let(:options) { {} }

      context 'when token type is application' do
        let(:token_type) { :application }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing required parameter "query"'
          )
        end
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing required parameter "query"'
          )
        end
      end
    end

    context 'with options' do
      let(:options) { { query: query } }

      let(:query) { 'angel of death' }

      shared_examples 'successful data' do
        describe 'data' do
          subject { super().data }

          let(:expected_category_attributes) do
            an_object_having_attributes(
              id: a_string_matching(/^\d+$/),
              name: a_string_including('Angels of Death'),
              box_art_url: url_string
            )
          end

          it { is_expected.to include expected_category_attributes }
        end
      end

      context 'when token type is application' do
        let(:token_type) { :application }

        include_examples 'successful data'
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        include_examples 'successful data'
      end
    end
  end

  describe '#get_stream_key' do
    subject(:request) { client.get_stream_key(options) }

    context 'without options' do
      let(:options) { {} }

      context 'when token type is application' do
        let(:token_type) { :application }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing required parameter "broadcaster_id"'
          )
        end
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing required parameter "broadcaster_id"'
          )
        end
      end
    end

    context 'with options' do
      let(:options) { { broadcaster_id: broadcaster_id } }

      ## `StreamAssistantBot`
      let(:broadcaster_id) { '277558749' }

      context 'when token type is application' do
        let(:token_type) { :application }

        specify do
          expect { request }.to raise_error(
            Twitch::APIError, 'Missing User OAUTH Token'
          )
        end
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        describe 'data' do
          subject { super().data }

          let(:expected_data) do
            [
              {
                'stream_key' => '<STREAM_KEY>'
              }
            ]
          end

          it { is_expected.to eq expected_data }
        end
      end
    end
  end

  describe '#get_cheermotes' do
    subject(:request) { client.get_cheermotes(options) }

    shared_examples 'successful data' do
      describe 'data' do
        subject { super().data }

        let(:expected_cheermote_attributes) do
          an_object_having_attributes(
            prefix: a_string_matching(/^[a-z]{3,}$/i),
            tiers: including(
              an_object_having_attributes(
                min_bits: an_instance_of(Integer),
                id: a_string_matching(/^\d+$/),
                color: hex_color_string,
                images: an_object_having_attributes(
                  dark: an_object_having_attributes(
                    animated: including(
                      '1' => url_string,
                      '2' => url_string,
                      '4' => url_string
                    ),
                    static: including(
                      '1' => url_string,
                      '2' => url_string,
                      '4' => url_string
                    )
                  ),
                  light: an_object_having_attributes(
                    animated: including(
                      '1' => url_string,
                      '2' => url_string,
                      '4' => url_string
                    ),
                    static: including(
                      '1' => url_string,
                      '2' => url_string,
                      '4' => url_string
                    )
                  )
                ),
                can_cheer: true,
                show_in_bits_card: true
              )
            ),
            type: 'global_first_party',
            order: an_instance_of(Integer),
            last_updated: an_instance_of(Time),
            is_charitable: false
          )
        end

        it { is_expected.to include expected_cheermote_attributes }
      end
    end

    context 'without options' do
      let(:options) { {} }

      context 'when token type is application' do
        let(:token_type) { :application }

        include_examples 'successful data'
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        include_examples 'successful data'
      end
    end

    context 'with options' do
      let(:options) { { broadcaster_id: broadcaster_id } }

      ## `AlexWayfer`
      ## It has to be partner or affiliate.
      let(:broadcaster_id) { '117474239' }

      context 'when token type is application' do
        let(:token_type) { :application }

        include_examples 'successful data'
      end

      context 'when token type is user' do
        let(:token_type) { :user }

        include_examples 'successful data'
      end
    end
  end
end
