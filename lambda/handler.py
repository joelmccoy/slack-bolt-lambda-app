"""Slack Bolt Lambda Function Handler"""
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(_):
    """Lambda Entry Point"""
    logger.info("In hello world lambda!")

    message = "Hello from Lambda!"

    return {"body": message}
