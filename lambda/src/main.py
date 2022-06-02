"""main"""
import boto3
import os
from urllib.parse import unquote_plus

TAG_KEYS = os.environ["TAG_KEYS"].split()
TAG_VALUES = os.environ["TAG_VALUES"].split()
s3 = boto3.client("s3")


def lambda_handler(event, context):
    if "Records" not in event:
        return
    
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        key = unquote_plus(record["s3"]["object"]["key"], encoding="utf-8")
        try:
            res = s3.put_object_tagging(
                Bucket=bucket,
                Key=key,
                Tagging={
                    "TagSet": [
                        {
                            "Key": TAG_KEYS[i],
                            "Value": TAG_VALUES[i]
                        } for i in range(len(TAG_KEYS))
                    ]
                }
            )

            return res
        except Exception as e:
            print(e)
            print("Error getting object {} from bucket {}.".format(key, bucket))
            raise e
        





