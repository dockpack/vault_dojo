vault operator rekey -init -key-shares=3 -key-threshold=2 \
        -format=json | jq -r ".nonce" > nonce.txt
