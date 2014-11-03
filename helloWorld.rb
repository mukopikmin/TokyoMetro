require 'sinatra'
require 'open-uri'
require 'openssl'
require 'json'
require 'uri'

ACCESS_TOKEN = ENV["ACCESS_TOKEN"]
API_ENDPOINT = "https://api.tokyometroapp.jp/api/v2/"

DATAPOINTS = "datapoints"
PLACES = "palces"

POI = "ug:Poi"
TRAIN = "odpt:Train"
STATION = "odpt:Station"
CONSUMER_KEY = "acl:consumerKey"
TYPE = "rdf:type"
TITLE = "dc:title"
OPERATOR = "odpt:operator"

get '/' do
  @date = Time.now
  @stations = get_stations
  @passengers = get_passengers("TokyoMetro.Marunouchi.Tokyo")
  @exits = get_exits("東京")
  @title = "Tokyo metro sample app"
  erb :index
end

get '/:station' do |station|
  @selected_station = station
  @date = Time.now
  @stations = get_stations
  @passengers = get_passengers("TokyoMetro.Marunouchi.Tokyo")
  @exits = get_exits("東京")
  @title = "Tokyo metro sample app"
  erb :station
end

def create_query(params)
  query = "?"
  params.each{|key, value|
    query += key + "=" + value + "&"
  }
  return query.chop
end

def get_stations
  params = {CONSUMER_KEY => ACCESS_TOKEN, TYPE => STATION}
  url = API_ENDPOINT + DATAPOINTS + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end

def get_exits station
  params = {CONSUMER_KEY => ACCESS_TOKEN, TYPE => POI, TITLE => URI.encode(station)}
  url = API_ENDPOINT + DATAPOINTS + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end

def get_passengers station_id
  params = {CONSUMER_KEY => ACCESS_TOKEN}
  url = API_ENDPOINT + DATAPOINTS + '/odpt.Station:' + station_id + create_query(params)
  puts url
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end