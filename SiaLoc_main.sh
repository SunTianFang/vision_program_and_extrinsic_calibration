#!/bin/bash
# command content
##########################################################################
sync
##########################################################################

#加入运行环境库路径
source /etc/profile
sudo ldconfig

echo "start app"

sudo chmod 777 /userdata/CarryBoy/NAV/*


ntpd_id=`ps -ef | grep ntpd | grep -v "grep" | awk '{print $2}'`
echo "Get ntpd $ntpd_id"

for id in $ntpd_id
do
    kill -9 $id  
    echo "killed ntpd $id"  
done

#sudo /userdata/CarryBoy/TCPDUMP/tcpdump -i any udp and port 123 -w /userdata/CarryBoy/TCPDUMP/719.cap
#ntpd
chmod 777 /userdata/CarryBoy/NAV/ntpd
sudo /userdata/CarryBoy/NAV/ntpd /userdata/CarryBoy/NAV/ntp.conf

sudo chmod 777 -R /dev

export LD_LIBRARY_PATH=/userdata/CarryBoy/NAV/visloc/lib:$LD_LIBRARY_PATH
cd /userdata/CarryBoy/NAV/visloc/bin
sleep 5
Process_lxind_visloc=`ps -ef | grep "lxind_visloc" | grep -v grep | awk '{print $2}'`
    echo "Find lxind_visloc Process PID: $Process_lxind_visloc"
    if [[ -n "$Process_lxind_visloc" ]]; then
        echo "lxind_visloc Process Exist: $Process_lxind_visloc"
    else
        ./lxind_visloc &
    fi
chmod 777 /userdata/CarryBoy/NAV/robo_localization
echo siasun | sudo -S nohup /userdata/CarryBoy/NAV/robo_localization >/dev/null 2>&1 &

exit 0


