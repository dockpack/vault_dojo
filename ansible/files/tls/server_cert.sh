#!/bin/bash
consul tls cert create -server -additional-dnsname=server01.consul -additional-dnsname=server02.consul -additional-dnsname=server03.consul -days 512
