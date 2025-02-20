require 'net/http'
require 'uri'
require 'json'
require 'open-uri'

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!, only: :line_callback
  skip_after_action :verify_authorized, only: :line_callback

  def line_callback
    response = get_line_access_token(params)
    profile_info = get_line_user_info(response)
    user = get_user(profile_info)
    sign_in user

    redirect_to root_path
  end

  private

  def get_user(profile_info)
    user = User.find_by(email: profile_info["email"])
    if !user
      user = User.create!(email: profile_info["email"], password: "asdfasdf", first_name: profile_info["name"])
      image = URI.parse(profile_info["picture"]).open
      user.photo.attach(io: image, filename: "#{user.email}_profile_picture.png", content_type: "image/png")
    end

    return user
  end
#
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
