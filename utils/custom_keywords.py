import os
import json
from robot.api import logger

class CustomKeywords:

    def get_current_timestamp_for_folder(self):
        from datetime import datetime
        return datetime.now().strftime("%Y-%m-%d_%H%M%S")

    def log_message(self, message):
        logger.info(message)

    def get_environment_variable(self, var_name):
        return os.getenv(var_name)

    def convert_string_to_json(self, json_string):
        return json.loads(json_string)


