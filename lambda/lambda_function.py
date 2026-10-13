import json
import boto3
import os
import uuid  # Added for better unique filenames

def lambda_handler(event, context):
    # Parse the event payload; using body to simulate API-style events
    try:
        body = json.loads(event.get('body', '{}'))
    except Exception as e:
        return {
            "statusCode": 400,
            "headers": cors_headers(),  # Added CORS headers
            "body": json.dumps({"error": "Invalid JSON", "message": str(e)})
        }
    
    text = body.get('text')
    # Get voice from request, default to Kevin if none provided
    voice_id = body.get('voice', 'Kevin')  # Added voice selection
    
    # Generate a unique filename using UUID
    filename = f"output/{uuid.uuid4()}.mp3"  # Better unique filename generation
    bucket_name = os.environ.get('BUCKET_NAME')
    
    if not text or not bucket_name:
        return {
            "statusCode": 400,
            "headers": cors_headers(),  # Added CORS headers
            "body": json.dumps({"error": "Missing text or bucket name"})
        }
    
    polly_client = boto3.client('polly')
    s3_client = boto3.client('s3')
    
    try:
        # Synthesize the speech using Amazon Polly with the selected voice
        response = polly_client.synthesize_speech(
            Text=text,
            OutputFormat='mp3',
            VoiceId=voice_id,  # Now using the voice from the request
            Engine='neural'  # Specify the engine type (generative, long-form, neural, or standard)
        )
        
        if "AudioStream" not in response:
            raise Exception("No audio stream found in Polly response.")
        
        # Upload the resulting MP3 file to S3
        s3_client.put_object(
            Bucket=bucket_name,
            Key=filename,
            Body=response['AudioStream'].read(),
            ContentType="audio/mpeg"
        )
        
        # Generate a pre-signed URL valid for 1 hour (3600 seconds)
        presigned_url = s3_client.generate_presigned_url(
            'get_object',
            Params={'Bucket': bucket_name, 'Key': filename},
            ExpiresIn=3600
        )
        
        return {
            "statusCode": 200,
            "headers": cors_headers(),  # Added CORS headers
            "body": json.dumps({
                "message": "Audio generated successfully!",
                "audioUrl": presigned_url  # Changed key name to match frontend expectations
            })
        }
        
    except Exception as e:
        return {
            "statusCode": 500,
            "headers": cors_headers(),  # Added CORS headers
            "body": json.dumps({
                "error": "Processing failed",
                "message": str(e)
            })
        }

# Added function for CORS headers
def cors_headers():
    return {
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
    }