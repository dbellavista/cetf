require 'google/omniauth'

OmniAuth.config.logger = Rails.logger

SERVICES = YAML.load(File.open("#{::Rails.root}/config/oauth.yml").read)

#if Rails.env.development?
#  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
#end

Rails.application.config.middleware.use OmniAuth::Builder do

    SERVICES.keys.each do |k|
      provider k, SERVICES[k]['key'], SERVICES[k]['secret'], SERVICES[k]['parameters']
    end

end
