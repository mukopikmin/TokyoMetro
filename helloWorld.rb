require 'sinatra'
require 'open-uri'
require 'openssl'
require 'json'
require 'uri'

ACCESS_TOKEN = ENV["ACCESS_TOKEN"]
API_ENDPOINT = "https://api.tokyometroapp.jp/api/v2/"

get '/' do
  @date = Time.now
  @stations = get_stations
  @passengers = get_passengers("TokyoMetro.Marunouchi.Tokyo")
  @exits = get_exits("東京")
  @title = "Tokyo metro sample app"
  erb :index
end

get '/:name' do
  # name = "TokyoMetro.Ginza.AoyamaItchome"
  name = params[:name]
  @station = get_station(name)
  @selected_station = name
  @date = Time.now
  @stations = get_stations
  @passenger = get_passengers(@station["odpt:passengerSurvey"][0])[0]["odpt:passengerJourneys"]
  @exits = get_exits(@station["dc:title"])
  @title = "Tokyo metro sample app"
  erb :station
end

def create_query(params)
  query = "?"
  params.each do |key, value|
    query += key + "=" + value + "&"
  end
  return query.chop
end

def get_station(station)
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "odpt:Station", "owl:sameAs" => station}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)[0]
end

def get_stations
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "odpt:Station"}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end

def get_exits(station)
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "ug:Poi", "dc:title" => URI.encode(station)}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end

def get_passengers(station)
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "odpt:PassengerSurvey", "owl:sameAs" => station}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  puts url
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end
