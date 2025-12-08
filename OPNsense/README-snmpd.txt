check that net-snmp is installed under System -> Firmware ->Packages

this is no longer supported in the UI :(, but you can run from shell

@AI results...
This is unsupported and may be removed or break on upgrades.
You'd have to hand-write and maintain /usr/local/etc/snmp/snmpd.conf.

. Use /conf/rc.bootup (OPNsense 22.1+)
OPNsense allows running custom shell commands at boot with the /conf/rc.bootup script.

Place your startup command in /conf/rc.bootup (create it if it doesn’t exist).
Make sure it is executable: chmod +x /conf/rc.bootup
After every boot, this script is called late in the boot sequence.
Example /conf/rc.bootup:

#~
#!/bin/sh
# Start net-snmp daemon if not running
if [ -x /usr/local/sbin/snmpd ]; then
    /usr/local/sbin/snmpd -c /usr/local/etc/snmp/snmpd.conf
fi
#~

This will not be overwritten by OPNsense updates or config saves.
