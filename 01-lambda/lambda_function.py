import json


def lambda_handler(event, context):
    name = event.get("name", "world") if isinstance(event, dict) else "world"
    body = {"message": f"Hello, {name}!"}

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(body),
    }
