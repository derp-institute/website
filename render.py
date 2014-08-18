#!/usr/bin/env python

import sys
import json
import os
import subprocess
import time

from re import sub
from datetime import datetime

from mako.template import Template
from mako.lookup import TemplateLookup


def main():
   cmd_path, data_path, template_path = sys.argv

   with open(data_path) as f:
      data = json.load(f)

   output = subprocess.check_output([
       'git',
       '-C', os.path.dirname(cmd_path),
       'log', '--follow', '--format=%at',
       data_path,
   ])
   last_date = int(output.strip().split('\n')[0])
   data_timestamp = datetime.fromtimestamp(last_date)

   lookup = TemplateLookup(directories=['src'])
   template = lookup.get_template(template_path)
   html = template.render(data=data, data_timestamp=data_timestamp)
   # minify html inter-tag whitespace
   html = sub(r"\s+", " ", html)
   html = sub(r">\s*(.*?)\s*<", ">\g<1><", html)
   print html


if __name__ == "__main__":
   main()
