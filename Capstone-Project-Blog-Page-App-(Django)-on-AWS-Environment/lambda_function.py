import json
import boto3

def lambda_handler(event, context):
    s3 = boto3.client("s3")
    
    if event:
        print("Event: ", event)
        filename = str(event['Records'][0]['s3']['object']['key'])
        timestamp = str(event['Records'][0]['eventTime'])
        event_name = str(event['Records'][0]['eventName']).split(':')[0][6:]
        
        filename1 = filename.split('/')
        filename2 = filename1[-1]
        
        dynamo_db = boto3.resource('dynamodb')
        dynamoTable = dynamo_db.Table('awscapstoneDynamo')
        
        dynamoTable.put_item(Item = {
            'id': filename2,
            'timestamp': timestamp,
            'Event': event_name,
        })
        
    return "Lambda success"