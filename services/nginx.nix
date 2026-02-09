{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedBrotliSettings = true;
    recommendedProxySettings = true;

    commonHttpConfig = ''
      ssl_ecdh_curve X25519:prime256v1:secp384r1;
    '';
  };
}
