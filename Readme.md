# Installation 

#### Prerequisites
  - Setup EC2 instance on Amazon
  - Setup MySQL on EC2 instance
  - Setup ElasticSearch on EC2 instance

#### Steps to Upload data
**[Step#1]** : Once the elasticsearch is up and running on AWS EC2 instance, we have to setup index name. We can do that by sending a PUT request using `curl`, or by using a REST client such as *Insomnia*. We also need to provide mapping of the fields defining data-types and relationship between entities.

```sh
curl -XPUT 'http://ec2instance:9200/busdb' -H 'Content-Type: application/json' -d '
  {
    "mappings": {
      "_doc": {
        "properties": {
          "trip_join": { 
            "type": "join",
            "relations": {
              "trip": "stoptime"
            }
          },
          "block_id": { "type": "keyword" },
          "route_id": { "type": "keyword" },
          "trip_headsign": { "type": "keyword" },
          "service_id": { "type": "keyword" },
          "shape_id": { "type": "keyword" },
          "trip_id": { "type": "keyword" },
          "stop": {
  	        "type": "nested",
            "properties": {
              "name_stop": { "type": "keyword" },
              "stop_id": { "type": "integer" },
              "lat": { "type": "double" },
              "lon": { "type": "double" }
            }
          },
          "arrival_time": { "type": "date", "format": "HH:mm:ss" },
          "departure_time": { "type": "date", "format": "HH:mm:ss" },
          "stop_sequence":{ "type":"integer" }
        }
      }    
    }
  }
'
```

**[Step#2]** : Prepare the documents to be indexed on elasticsearch. We used ruby scripts `stoptimes.rb` and `trips.rb` to prepare our data and specify index and parent-child relationships. 

**Sample parent example (Trip) after data preperation:**
```sh
{"index":{"_index":"busdb","_type":"_doc","_id":"5807912-2012_05M-12MferWD-Weekday-00"}}
{"block_id":"a_1968470","route_id":"FerD-116","trip_headsign":"FERRY TO HALIFAX","service_id":"2012_05M-12MferWD-Weekday-00","shape_id":"FerD0004","trip_id":"5807912-2012_05M-12MferWD-Weekday-00","trip_join":"trip"}
```

**Sample child example (Stoptime) after data preperation:**
```sh
{"index":{"_index":"busdb","_type":"_doc","_routing":"6513332-2012_05M-1205BRwd-Weekday-02"}}
{"trip_id":"6513332-2012_05M-1205BRwd-Weekday-02","arrival_time":"13:00:00","departure_time":"13:00:00","stop_id":6940,"stop_sequence":1,"trip_join":{"name":"stoptime","parent":"6513332-2012_05M-1205BRwd-Weekday-02"},"stop":{"stop_id":6940,"name_stop":"hubley Centre","lat":44.7028,"log":-63.8582}}
```

**[Step#3]** : Now the data can be uploaded using the POST request to the the index we just created in Step#1. We suggest uploading the data as `binary json file` using a REST client to the following URL:
```
http://ec2instance:9200/busdb/_bulk
```

**[Step#4]** :
Once all the data is uploaded to appropriate index, we can perform search queries as described in the report. 