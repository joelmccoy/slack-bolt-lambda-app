"""Slack Bolt Lambda Function Handler"""
import logging
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)


# pylint: disable=unused-argument
def lambda_handler(event, context):
    """Lambda Entry Point"""
    logger.info("In hello world lambda!")

    message = "Hello from Lambda!"

    return {"statusCode": 200, "body": json.dumps(message)}
