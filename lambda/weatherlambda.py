import json
import urllib.request
import boto3

dynamodb = boto3.resource('dynamodb')

table = dynamodb.Table('Weathertable')

def lambda_handler(event, context):
    
     api_key = "2896b53ee1b1dc1840a13a676b798698"

city = "Kochi"

url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"

response = urllib.request.urlopen(url)

data = json.loads(response.read())

weather_data = {
        "city": data["name"],
        "temperature": str(data["main"]["temp"]),
        "humidity": str(data["main"]["humidity"]),
        "weather_condition": data["weather"][0]["main"]
}

table.put_item(Item=weather_data)

return weather_data
