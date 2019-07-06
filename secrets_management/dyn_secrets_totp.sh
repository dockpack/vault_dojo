#!/bin/bash

# The TOTP secrets engine generates time-based credentials according to the TOTP standard. 
vault secrets list|grep totp || vault secrets enable totp



