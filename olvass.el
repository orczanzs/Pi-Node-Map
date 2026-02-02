A Pi Node Map egy könnyű, valós idejű vizualizációs eszköz, amely megjeleníti a Pi Node‑od aktív peer kapcsolatait egy interaktív világtérképen. A program automatikusan felismeri a bejövő és kimenő TCP kapcsolatokat, lekéri a peer‑ek földrajzi adatait, majd színkódolt jelölőkkel és vonalakkal ábrázolja őket.

Mit tud a Pi Node Map?
Valós időben vizsgálja a 31400–31409 portokat

Megkülönbözteti az INBOUND és OUTBOUND kapcsolatokat

Lekéri a peer‑ek országát, városát, koordinátáit

Emoji zászlókat használ a My_Node és a peer‑ek megjelenítéséhez

Kiszámítja a peer‑ek helyi idejét időzóna alapján

Interaktív térképet készít Leaflet segítségével

Tiszta, áttekinthető felületet ad automatikus frissítéssel

Windows alatt fut PowerShellből, telepítés nélkül

Hogyan működik?
A script átvizsgálja a Pi Node portjain lévő aktív TCP kapcsolatokat.

Minden IP‑hez lekérdezi a geolokációt az ipwho.is API‑ból.

Létrehoz egy HTML fájlt, amely tartalmazza:

a világtérképet

a My_Node és peer jelölőket

színkódolt kapcsolatvonalakat

részletes információs buborékokat

A térkép automatikusan megnyílik a böngészőben.

Követelmények
Windows 10 vagy újabb

PowerShell 5.1 vagy PowerShell 7+

Internetkapcsolat (API + térképcsempék miatt)

Használat
Töltsd le a repót.

Tedd a PiNodeMap.ps1 scriptet és a qr.jpg fájlt egy mappába.

Indítsd a PowerShellt rendszergazdaként.

Navigálj a mappába:

Kód


Másolás
cd "C:\path\to\PiNodeMap"
Futtasd a scriptet:

Kód


Másolás
.\PiNodeMap.ps1
A program létrehozza a PiNodeMap.html fájlt és megnyitja.

Jelmagyarázat
🟢 INBOUND – mások csatlakoznak hozzád

🔵 OUTBOUND – te csatlakozol másokhoz

🔴 My_Node – a saját külső IP‑d helye

Támogatás
Ha tetszik a projekt, egy kávéval támogathatod:
Revolut: https://revolut.me/orczanzs

Licenc
A projekt nyílt forráskódú, szabadon használható és módosítható.