"""Slack Bolt Lambda Function Handler"""
import logging

from slack_bolt import App
from slack_bolt.adapter.aws_lambda import SlackRequestHandler

# process_before_response must be True when running on FaaS
app = App(process_before_response=True)


@app.middleware  # or app.use(log_request)
def log_request(logger, body, next):  # pylint: disable=redefined-builtin
    logger.debug(body)
    return next()


COMMAND = "/hello-bolt-python-lambda"


def respond_to_slack_within_3_seconds(body, ack):
    if body.get("text") is None:
        ack(f":x: Usage: {COMMAND} (description here)")
    else:
        title = body["text"]
        ack(f"Accepted! (task: {title})")


def process_request(respond, body):
    title = body["text"]
    respond(f"Completed! (task: {title})")


app.command(COMMAND)(ack=respond_to_slack_within_3_seconds, lazy=[process_request])

SlackRequestHandler.clear_all_log_handlers()
logging.basicConfig(format="%(asctime)s %(message)s", level=logging.DEBUG)


def handler(event, context):
    slack_handler = SlackRequestHandler(app=app)
    return slack_handler.handle(event, context)
