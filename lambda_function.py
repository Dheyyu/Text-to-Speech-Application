import json
import boto3
import os

def lambda_handler(event, context):
    # Parse the event payload; using body to simulate API-style events
    try:
        body = json.loads(event.get('body', '{}'))
    except Exception as e:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid JSON", "message": str(e)})
        }
    
    text = body.get('text')
    # Use a default key if none provided; adjust as needed
    output_key = body.get('output_key', f"output/audio_{int(context.aws_request_id[-4:], 16)}.mp3")
    bucket_name = os.environ.get('BUCKET_NAME')
    
    if not text or not bucket_name:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Missing text or bucket name"})
        }
    
    polly_client = boto3.client('polly')
    s3_client = boto3.client('s3')
    
    try:
        # Synthesize the speech using Amazon Polly
        response = polly_client.synthesize_speech(
            Text=text,
            OutputFormat='mp3',
            VoiceId='Kevin',  # You can change the voice as needed
            Engine='neural'  # Specify the engine type (generative, long-form, neural, or standard)
        )
        
        if "AudioStream" not in response:
            raise Exception("No audio stream found in Polly response.")
        
        # Upload the resulting MP3 file to S3
        s3_client.put_object(
            Bucket=bucket_name,
            Key=output_key,
            Body=response['AudioStream'].read(),
            ContentType="audio/mpeg"
        )
        
        # Generate a pre-signed URL valid for 1 hour (3600 seconds)
        presigned_url = s3_client.generate_presigned_url(
            'get_object',
            Params={'Bucket': bucket_name, 'Key': output_key},
            ExpiresIn=3600
        )
        
        return {
            "statusCode": 200,
            "headers": {"Access-Control-Allow-Origin": "*"},
            "body": json.dumps({
                "message": "Audio generated successfully!",
                "url": presigned_url
            })
        }
        
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": "Processing failed",
                "message": str(e)
            })
        }
