vault operator rekey -init -key-shares=3 -key-threshold=2 \
        -target="recovery" -format=json | jq -r ".nonce" > nonce.txt
