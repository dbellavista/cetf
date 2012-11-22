#!/usr/bin/ruby

require 'rubygems'
require 'rails/commands/server'
require 'rack'
require 'webrick'
require 'webrick/https'

module Rails
    class Server < ::Rack::Server
        def default_options
            super.merge({
                :Port => 3000,
                :environment => (ENV['RAILS_ENV'] || "development").dup,
                :daemonize => false,
                :debugger => false,
                :pid => File.expand_path("tmp/pids/server.pid"),
                :config => File.expand_path("config.ru"),
                :SSLEnable => true,
                :SSLVerifyClient => OpenSSL::SSL::VERIFY_NONE,
                :SSLPrivateKey => OpenSSL::PKey::RSA.new(
                       File.open("/etc/ssl/private/localhost.key").read),
                :SSLCertificate => OpenSSL::X509::Certificate.new(
                       File.open("/etc/ssl/newcerts/localhost.crt").read),
                :SSLCertName => [["CN", WEBrick::Utils::getservername]]
            })
        end
    end
end 
