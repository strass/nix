{
  virtualisation.quadlet.containers = {
    whoami = {
      autoStart = true;
      serviceConfig = {
        RestartSec = "10";
        Restart = "always";
      };
      containerConfig = {
        image = "docker.io/traefik/whoami:latest";
        publishPorts = ["127.0.0.1:8081:8080"];
        userns = "keep-id";
      };
    };
  };
}
