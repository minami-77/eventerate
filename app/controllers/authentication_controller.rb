require 'net/http'
require 'uri'
require 'json'

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!, only: :line_callback

  def line_callback
    response = get_line_access_token(params)
    profile_info = get_line_user_info(response)
    puts profile_info
    raise
  end

  private

  def get_line_access_token(params)
    uri = URI('https://api.line.me/oauth2/v2.1/token')
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/x-www-form-urlencoded')
    request.body = URI.encode_www_form(
      grant_type: 'authorization_code',
      code: params["code"],
      redirect_uri: ENV["REDIRECT"],
      client_id: ENV["CHANNEL_ID"],
      client_secret: ENV["CHANNEL_SECRET"],
    )
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    return JSON.parse(response.body)
  end

  def get_line_user_info(response)
    uri = URI('https://api.line.me/oauth2/v2.1/verify')
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/x-www-form-urlencoded')
    request.body = URI.encode_www_form(
      id_token: response["id_token"],
      client_id: ENV["CHANNEL_ID"],
    )
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    return JSON.parse(response.body)
  end
end
