#!/usr/bin/python2.7

from bs4 import BeautifulSoup
from lxml import html
import requests
import os
import datetime
import yaml
import re
import feedparser


def readConfiguration():
    # open the configuration file in read mode
    config_file = open('config.yml', 'r')
    # now load the yaml
    config = yaml.load(config_file)
    return config


def readFact(config):
    # get the rss page
    d = feedparser.parse(config['fact']['url'])
    # make the soup
    # soup = BeautifulSoup(page.text, "lxml")

    # get the fact
    data = dict()
    for i in range(0,5):
        data[str(i+1) + '_summary'] = unicode(d['entries'][i]['summary']).strip()
    
    # data['fact'] = re.sub(r'\s+', r' ', data['fact'])

    # lets find the quotes
    return data


def writeFact(data):
    # open the file for writitng
    fact_file = open('Downloads/fact.cml', 'w')
    # write the fact
    for key in data:
        fact_file.write(key + ':' + str(data[key]) + '\n')
    # close the file
    fact_file.close()


# read the configuration file
config = readConfiguration()
# read the quotes
data = readFact(config)
data['status'] = 'FILLED'
# write them to a file
writeFact(data)
