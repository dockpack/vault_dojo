#!/bin/bash

# Enable the versioned k/v secrets engine like the dev server has it.
vault secrets list|grep secret || vault secrets enable -path=secret/ -version=2 kv
