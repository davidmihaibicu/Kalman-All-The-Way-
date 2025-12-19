# Kalman-All-The-Way

Disclaimer: Materialul încărcat reprezintă momentan doar funcția principală din filtrul nostru Kallman.

### Dependinte

HDL Coder Matlab, Simulink

#### informatii HDL Coder Matlab
Mai multe despre HDL Coder - asemenea RHDL, orice cod generat fără erori din HDL Coder, este sintetizabil. Acesta mappează automat funcții matematice în mod serial, nu foarte eficient. 
La polul opus, acesta poate implementa foarte eficient block-urile compatibil HDL din Simulink, Stateflow-uri și Simscape (partea electrică).

În rezolvarea noastră momentan ne folosim doar de Simulink. ( Stateflow-ul va fi adăugat în a doua parte a implementării).

## Ideea

Am încercat pentru a realiza algoritmul classic de filtru Kallman, să folosim algoritmul lui Faddevv de găsire a complementului Schur.
Astfel, orice filtru Kallman putea fi realizat prin 9 parcurgeri a acestui algoritm cu alte 4 matrici, pentru a obține noua estimare.
Pentru mai multe detalii despre cum ar fi trebuit folosit algoritmul lui Faddev se găsesc în paper-ul: DOI 10.1155/ASP/2006/89186 capitolul 6.2 Table 2.

## Solutia noastra


### Fisiere Incarcate

Fisierele încarcate reprezintă încercarea noastră de a realiza algoritmul lui Faddevv prin cea mai simplă arhitectură vectorială sistolică (systollic array architecture). Aceasta poate fi vazută în capitolul 2.2 figura 2 din DOI 10.1155/ASP/2006/89186. Aceasta arhitectură presupune un trapez dreptunghic, cu baza egala cu lățimea matricei de estimare a formei schur. 
- array_2x2.slx  - subsistem ce conține alte 2 subsisteme (boundary_subsys si inner_subsys), acesta ar trebui să primească o matrice preîntârziată pe coloane conform algoritmului.
- dut_test.slx - acesta este un sistem de test împreună cu model_test.m făcut ca să verificăm dacă algoritmul este bun. În acest cod dăm niște matrici A, B, C, D, computăm E = D + C (A^-1) B matematic si după aceea apelăm modelul nostru.

Problemele modelului nostru au apărut inițial de la faptul cum Simulink manageruiește valabilitatea datelor. Chiar dacă în sine codul respectă diagrama din paper, anumite quirk-uri ale simulink-ului ne-au făcut să folosim câteva block-uri care nu fac parte din librăria de HDL Coder doar pentru simulare, pe când într-un FPGA nu ar fi nevoie de ele(ex: Zero-hold block).
Avem astfel niște probleme ciudate când analizăm cu Logic Analyzer semnalele de ieșire din array_2x2. Cel puțin semnalele de intrare le-am verificat și sunt corecte.


Din păcate deși codul este bun și HDL Coder ne permite să generăm cod de Verilog/VHDL, rezultatul nu este în totalitate bun. 
Încă nu am găsit eroarea.

Ore pierdute momentan în găsirea bug-ului: 8 ore.


#### Next
Gasim eroarea sau incercam alta implementare.
In cazul in care gasim eroarea, vom folosii un Automat finit determinat pentru a ne duce prin toate stările pentru actualizările matricilor A, B, C și D. și obținerea estimării următoare.
