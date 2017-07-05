# frozen_string_literal: true

shared_examples_for 'Api authenticateable' do
  context 'Unauthorized' do
    let(:path) { "/api/v1/#{subpath}" }

    request_list.each do |http_method, subpaths_list|
      [*subpaths_list].each do |subpath|

        describe "#{http_method.upcase} /#{subpath}" do
          let!(:question) { create :question }
          let(:subpath) { subpath }

          it 'returns 401 if have no access_token' do
            send http_method, path, params: { format: :json }

            expect(response.status).to eq 401
          end

          it 'returns 401 if access_token is invalid' do
            send http_method, path, params: { access_token: '12342', format: :json }

            expect(response.status).to eq 401
          end
        end
      end
    end
  end
end
