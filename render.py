#!/usr/bin/env python

import sys
import json

from re import sub

from mako.template import Template
from mako.lookup import TemplateLookup


def main():
   cmd_path, data_path, template_path = sys.argv

   with open(data_path) as f:
      data = json.load(f)

   lookup = TemplateLookup(directories=['src'])
   template = lookup.get_template(template_path)
   html = template.render(data=data)
   # minify html inter-tag whitespace
   html = sub(r"\s+", " ", html)
   html = sub(r">\s*(.*?)\s*<", ">\g<1><", html)
   print html


if __name__ == "__main__":
   main()
