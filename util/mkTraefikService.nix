# Utility function to simplify adding Traefik service configurations
{
  name,
  fqdn,
  port,
  host ? "localhost",
  method ? "http",
  extraRouterConfig ? {},
  extraServiceConfig ? {},
  ...
}: {
  http.routers."${name}" = {
    rule = "Host(`${name}.${fqdn}`)";
    service = name;
    # Allow additional router configurations
    inherit (extraRouterConfig);
  };
  http.services."${name}" = {
    loadBalancer.servers = [
      {
        url = "${method}://${host}:${toString port}";
      }
    ];
    # Allow additional service configurations
    inherit (extraServiceConfig);
  };
}
# To use:
#   services.traefik.dynamicConfigOptions = mkTraefikService {
#     name = name;
#     fqdn = fqdn;
#     port = port;
#   };

