Rails.application.config.middleware.use OmniAuth::Builder do
  provider :clef, ENV['CLEF_APP_ID'], ENV['CLEF_APP_SECRET']
end
