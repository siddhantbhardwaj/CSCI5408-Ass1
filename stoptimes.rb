require 'json'

stops_file = File.read('stops_nn.json')
stops_list = JSON.parse(stops_file)
hash = {}
stops_list.each do |row|
  hash[row["stop_id"]] = row
end

stoptimes_file = File.read('stoptimes_nn.json')
stoptimes_json = JSON.parse(stoptimes_file)

File.open('stoptimes.json', 'w') do |file|
  stoptimes_json.each do |row|
    index = {
      "index": {
        "_index": "busdb",
        "_type": "_doc",
        "_routing": row["trip_id"]
      }
    }
    row = row.merge({
      "trip_join": { "name": "stoptime", "parent": row["trip_id"] },
      "stop": hash[row["stop_id"]]
    })
    file.puts index.to_json
    file.puts row.to_json
  end
end