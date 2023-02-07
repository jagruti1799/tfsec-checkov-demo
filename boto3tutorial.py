import json
import boto3

client=boto3.client('ec2','us-east-2')

ec2i = client.describe_instances(
    Filters=[
        { "Name": "instance-state-name", "Values": ["running"] }
    ]
)

spot_requests = []
requests = client.describe_spot_instance_requests(SpotInstanceRequestIds=spot_requests).get('SpotInstanceRequests')

def lambda_handler(event, context):

    print ("Total Running Instances")
    for reservation in ec2i['Reservations']:
        for instance in reservation['Instances']:
            for name in instance['Tags']:
                print("Instance_Image ID: {} Instance_Type: {} Instance_Name: {}"
                    .format(instance['InstanceId'],instance['InstanceType'],name['Value']))
            
    print ("Terminating Spot instances")
    for request in requests:        
        if (request['Type'] == 'one-time') and (request['State'] == 'active'):
            #client.terminate_instances(InstanceIds=[request['InstanceId']])
            #client.cancel_spot_instance_requests(SpotInstanceRequestIds=[request['SpotInstanceRequestId']])
            print("Terminating One-Time spot instance with ID: {}", request['InstanceId'])
        
       
        elif (request['Type'] == 'persistent') and (request['State'] == 'active'):
            #client.stop_instances(InstanceIds=[request['InstanceId']])
            print("Stopping Persistent spot instance with ID: {}", request['InstanceId'])

    return {
        'statusCode': 200,
        'body': json.dumps('')
    }


