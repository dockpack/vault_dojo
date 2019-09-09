vault write -field=signed_key ssh-client-signer/sign/admin-role \
    public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub

chmod 600 $HOME/.ssh/id_rsa-cert.pub
ssh-keygen -Lf ~/.ssh/id_rsa-cert.pub
