import json
import boto3
from datetime import datetime

s3 = boto3.client('s3')

BUCKET_NAME = 'weatherdata9'


def lambda_handler(event, context):

    print(event)
    
    for record in event['Records']:

        new_image = record['dynamodb'].get('NewImage', {})

        data = {}
        
        for key, value in new_image.items():
            data[key] = list(value.values())[0]
            
        file_name = f"weather_{datetime.now()}.json"
        
        response = s3.put_object(
            Bucket=BUCKET_NAME,
            Key=file_name,
            Body=json.dumps(data,indent=4)
        )

        print(response)
        
        return {
        'statusCode': 200
    }
        

