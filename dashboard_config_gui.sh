#!/bin/bash

whiptail --title "Honeynet BSSN" --msgbox \
"
                                                                             
 _____                         _      _____ ___    _____ _____ _____ _____   
|  |  |___ ___ ___ _ _ ___ ___| |_   |  |  |_  |  | __  |   __|   __|   | |  
|     | . |   | -_| | |   | -_|  _|  |  |  |  _|  | __ -|__   |__   | | | |  
|__|__|___|_/_|___|_  |_/_|___|_|     \___/|___|  |_____|_____|_____|_|___|  
                  |___|                                                      
" 0 0

function display_result() {
  whiptail --title "$1" \
    --msgbox "$result" 0 0
}

function advancedMenu() {
 while true; do
    ADVSEL=$(whiptail --title "Pilihan Menu" --fb --menu "Menu" 0 0 10 \
        "1" "Install ELK" \
        "2" "Install Honeypot GUI" \
        "3" "Konfigurasi MongoDB" \
        "4" "Konfigurasi Metabase" \
        "5" "Jalankan / Restart Honeypot" \
        "6" "Matikan Honeypot" \
        "7" "Cek Pengiriman Log ke Server" \
        "8" "Cek Daftar Sensor Berjalan, Image & Volume Terpasang" \
        "9" "Cek Status Port" \
        "10" "Masuk Honeypot Cowrie" \
        "11" "Masuk Honeypot Dionaea" \
        "12" "Masuk Honeypot Glastopf" \
        "13" "Cek Log, Binaries & Bistreams Dionaea" \
        "14" "Hapus Honeypot" 3>&1 1>&2 2>&3)
    exit_status=$?
    if [ $exit_status == 1 ] ; then
      clear
      exit
    fi
    case $ADVSEL in
        1 )
          TERM=ansi whiptail --title "Install ELK" --infobox "Instalasi ELK berjalan" 8 78
          ./install-ELK.sh
        ;;
        2 )
          TERM=ansi whiptail --title "Install Honeypot GUI" --infobox "Instalasi Honeypot berjalan" 8 78
          ./install-ELK.sh
        ;;
        3 )
          TERM=ansi whiptail \
            --title "Konfigurasi MongoDB" \
            --textbox doc/mongodb.txt 16 78
          sudo mongosh
        ;;
        4 )
          TERM=ansi whiptail \
            --title "Konfigurasi Metabase" \
            --textbox doc/metabase.txt 16 78
        ;;
        5 )
          result=$(sudo docker network prune -f && sudo docker-compose down && sudo docker-compose up -d)
          display_result "Restart Honeypot"
        ;;
        6 )
          result=$(sudo docker-compose down)
          display_result "Stop Honeypot"
        ;;
        7 )
          TERM=ansi whiptail --title "Cek Pengiriman Log ke Server" --infobox "Cek Pengiriman Log ke Server" 8 78
          sudo tcpdump -nnNN -A port 10000
        ;;
        8 )
          result=$(sudo docker ps && sudo docker image ls && sudo docker volume ls)
          display_result "Cek Daftar Sensor Berjalan, Image & Volume Terpasang"
        ;;
        9 )
          result=$(sudo netstat -tulnp && sudo docker exec -it dionaea /bin/bash -c "netstat -atn")
          display_result "Cek Status Port"
        ;;
        10 )
          TERM=ansi whiptail \
            --title "Konfigurasi Elasticsearch" \
#            --textbox doc/cowrie.txt 16 78
          sudo nano /etc/elasticsearch/elasticsearch.yml
        ;;
        11 )
          TERM=ansi whiptail \
            --title "Konfigurasi Logstash" \
#            --textbox doc/dionaea.txt 16 78
          sudo nano /etc/logstash/logstash.yml
        ;;
        12 )
          TERM=ansi whiptail \
            --title "Konfigurasi Kibana" \
#            --textbox doc/glastopf.txt 16 78
          sudo nano /etc/kibana/kibana.yml
        ;;
        13 )
           result=$(sudo docker exec -it dionaea /bin/bash -c "ls -lh /opt/dionaea/var/log | tail -5; ls -lh /opt/dionaea/var/lib/dionaea/binaries | tail -5;ls -lh /opt/dionaea/var/lib/dionaea/bistreams | tail -5")
           display_result "Cek Log, Binaries & Bistreams Dionaea"
        ;;
        14 )
           whiptail --title "Konfirmasi" --yesno "Apakah anda yakin akan menghapus seluruh Honeypot?" 8 78
              if [[ $? -eq 0 ]]; then
                 TERM=ansi whiptail --title "Honeynet BSSN" --infobox "Penghapusan Honeypot" 8 78
                 ./delete-honeypot.sh
                  whiptail --title "Honeynet BSSN" --msgbox "Seluruh Honeypot berhasil dihapus" 8 78
              elif [[ $? -eq 1 ]]; then
                  whiptail --title "Honeynet BSSN" --msgbox "Honeypot batal dihapus." 8 78
              elif [[ $? -eq 255 ]]; then
                  whiptail --title "Honeynet BSSN" --msgbox "Keluar dari proses Hapus Honeypot" 8 78
              fi
        ;;
    esac
  done
}
advancedMenu
