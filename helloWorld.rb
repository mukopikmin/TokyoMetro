require 'sinatra'
require 'open-uri'
require 'openssl'
require 'json'
require 'uri'

ACCESS_TOKEN = ENV["ACCESS_TOKEN"]
API_ENDPOINT = "https://api.tokyometroapp.jp/api/v2/"
TITLE = "YORIMICHI SEARCH"

get '/' do
  @railways = get_railways
  @stations = get_stations
  @title = TITLE
  erb :index
end

get '/:station' do
  @station = get_station(params[:station])
  @passenger = get_passengers(@station["odpt:passengerSurvey"][0])[0]["odpt:passengerJourneys"].to_i / 500
  @exits = get_exits(@station["dc:title"])
  @title = TITLE
  erb :station
end

# get '/:station/:exit' do
#   station = params[:station]
#   exit = params[:exit]
#   @station = get_station(station)
#   @exit = get_exit(exit)
#   @title = TITLE
#   erb :exit
# end

def create_query(params)
  query = "?"
  params.each do |key, value|
    query += key + "=" + value + "&"
  end
  return query.chop
end

def get_station(station)
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "odpt:Station", "odpt:stationCode" => station}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)[0]
end

def get_stations
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "odpt:Station"}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end

def get_exit(exit)
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "ug:Poi", "dc:title" => URI.encode(exit)}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)[0]
end

def get_exits(station)
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "ug:Poi", "dc:title" => URI.encode(station)}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end

def get_passengers(station)
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "odpt:PassengerSurvey", "owl:sameAs" => station}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  p url
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end

def get_railways
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "odpt:Railway"}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end

def get_station_by_railway(railway)
  params = {"acl:consumerKey" => ACCESS_TOKEN, "rdf:type" => "odpt:Railway", "odpt.railway" => railway}
  url = API_ENDPOINT + "datapoints" + create_query(params)
  return JSON.parse(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
end