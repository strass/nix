{
  knownHosts = [
    {
      hostNames = ["myhost" "myhost.mydomain.com" "10.10.1.4"];
      publicKeyFile = ./pubkeys/myhost_ssh_host_dsa_key.pub;
    }
    {
      hostNames = ["myhost2"];
      publicKeyFile = ./pubkeys/myhost2_ssh_host_dsa_key.pub;
    }
  ];
}
