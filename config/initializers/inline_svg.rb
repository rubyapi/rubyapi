# frozen_string_literal: true

InlineSvg.configure do |config|
  config.asset_finder = InlineSvg::WebpackAssetFinder
end
