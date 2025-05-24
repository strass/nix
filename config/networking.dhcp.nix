{
  subnet = "192.168.1";
  ip-assignments = {
    hive.lan = "${lan.subnet}.10";
    gamer.lan = "${lan.subnet}.123";
    framework.lan = "${lan.subnet}.71";
    router.lan = "${lan.subnet}.92";
  };
}
