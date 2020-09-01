API_KEY = ENV['API_KEY'] || 'secret'
def api_key_valid?(key)
  key == API_KEY
end
