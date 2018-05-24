require 'json'

trips_file = File.read('trips_nn.json')
trips_list = JSON.parse(trips_file)

File.open('trips.json', 'w') do |file|
  trips_list.each do |row|
    index = {
      "index": {
        "_index": "busdb",
        "_type": "_doc",
        "_id": row["trip_id"]
      }
    }
    row = row.merge({ "trip_join": "trip" })
    file.puts index.to_json
    file.puts row.to_json
  end
end
