# <Unseal Key 1>
vault operator rekey -nonce=$(cat nonce.txt) $1
