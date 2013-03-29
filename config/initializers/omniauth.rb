Rails.application.config.middleware.use OmniAuth::Builder do
  provider :clef, 'bc7b3e3fa9ac6ad3f97df4bb03a5a0f6', 'c2d7607f97ba968604f999cd6918aac6'
end