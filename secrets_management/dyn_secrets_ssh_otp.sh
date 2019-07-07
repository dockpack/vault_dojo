#vault secrets enable ssh
vault write ssh/roles/otp_key_role \
    key_type=otp \
    default_user=guest \
    cidr_list=192.168.122.1/29
