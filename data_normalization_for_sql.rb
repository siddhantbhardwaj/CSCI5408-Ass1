require "csv"

def correct_time(ts)
  timesplit = ts.split(":")
  hr = timesplit[0].to_i
  if hr  >= 24
    hr = 24 - hr
    timesplit[0] = hr
  end
  timesplit.join(":")
end

CSV.open("./stoptimes_new.csv", "w") do |csv|
  csv << ["trip_id", "arrival_time", "departure_time", "stop_id", "stop_sequence"]
  CSV.foreach('./stoptimes.csv', headers: true) do |row|
    arrival_time = row[1]
    departure_time = row[2]
    row[1] = correct_time(arrival_time)
    row[2] = correct_time(departure_time)
    csv << row
  end
end