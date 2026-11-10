Fs_e = 1 / Te; 

ws1_hz = 1.0;  
wp1_hz = 1.5;  

wp2_hz = 4.3;
ws2_hz = 4.8;

% Normalizamos
Wp = [wp1_hz, wp2_hz] / (Fs_e / 2);
Ws = [ws1_hz, ws2_hz] / (Fs_e / 2);

Rp = 1;  % Rizado permitido
Rs = 40; % Aplastamiento del ruido

% Diseño del filtro Pasa Banda
[N_e, Wn_e] = ellipord(Wp, Ws, Rp, Rs);
[b_e, a_e] = ellip(N_e, Rp, Rs, Wn_e);

ye_filtrada = filter(b_e, a_e, ye);

% Espectro en Frecuencia 
L_e = length(ye);
f_eje_e = Fs_e * (0:floor(L_e/2)) / L_e;

P1_ye = abs(fft(ye)/L_e); P1_ye = P1_ye(1:floor(L_e/2)+1); P1_ye(2:end-1) = 2*P1_ye(2:end-1);
P1_yefilt = abs(fft(ye_filtrada)/L_e); P1_yefilt = P1_yefilt(1:floor(L_e/2)+1); P1_yefilt(2:end-1) = 2*P1_yefilt(2:end-1);

figure;
plot(f_eje_e, P1_ye, 'r', 'LineWidth', 1.5); hold on;
plot(f_eje_e, P1_yefilt, 'k--', 'LineWidth', 2.5);
title(['Espectro: Filtro Elíptico Pasa Banda (Orden ', num2str(N_e), ')']);
xlabel('Frecuencia (Hz)'); ylabel('Amplitud');
legend('Señal Original (ye)', 'Señal Filtrada');
xlim([0 (Fs_e/2)]); 
grid on;

% Diagrama de Bode
figure;
[m_e, f_e, w_e] = dbode(b_e, a_e, Te);
m_e_db = 20 * log10(m_e);
semilogx(w_e, m_e_db, 'LineWidth', 2);
title('Diagrama de Bode - Filtro Elíptico Pasa Banda');
xlabel('Frecuencia (rad/s)'); ylabel('Magnitud (dB)');
grid on;