# frozen_string_literal: true

module Pruner::Api::Tree
  include Pruner::Errors

  def self.registered(app)
    app.get '/tree/:name' do |upstream_name|
      logger.info params
      raise InvalidParameters, "Invalid params: #{params}" if
        params['indicator_ids'] && !params['indicator_ids'].is_a?(Array)
      upstream_data = Pruner::UpstreamFetcher.call(upstream_name)
      ids = params['indicator_ids'].map(&:to_i)
      res = Pruner::TreePruner.new(upstream_data, ids).call
    end
  end
end