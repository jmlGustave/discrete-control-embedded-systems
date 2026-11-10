% Parámetros y diseño del filtro
Wc_hz = 0.07; 
Wc_rad = 2 * pi * Wc_hz;
lambda = tan(Wc_rad * Tb * 0.5);

% Coeficientes del filtro bilineal
b = [lambda/(1+lambda), lambda/(1+lambda)];
a = [1, -(1-lambda)/(1+lambda)];

L_b = length(yb);
y_bilineal = zeros(L_b, 1);
y_bilineal(1) = yb(1); % Condición inicial

for k = 2:L_b
    % y(k) = (1/a1) * (-a2*y(k-1) + b1*u(k) + b2*u(k-1))
    y_bilineal(k) = (1/a(1)) * (-a(2)*y_bilineal(k-1) + b(1)*yb(k) + b(2)*yb(k-1));
end
figure;
plot(ttb, yb, 'r:', 'LineWidth', 1); hold on;
plot(ttb, yb_sinruido, 'b', 'LineWidth', 1.5);
plot(ttb, y_bilineal, 'g--', 'LineWidth', 2);
title('Filtro Bilineal en el Dominio del Tiempo');
xlabel('Tiempo (s)'); ylabel('Amplitud');
legend('yb (Ruido)', 'yb\_sinruido (Ideal)', 'Señal Filtrada');
grid on;

Fs_b = 1 / Tb;
f_eje_b = Fs_b * (0:floor(L_b/2)) / L_b;


P1_ruido = abs(fft(yb)/L_b); P1_ruido = P1_ruido(1:floor(L_b/2)+1); P1_ruido(2:end-1) = 2*P1_ruido(2:end-1);
P1_limpia = abs(fft(yb_sinruido)/L_b); P1_limpia = P1_limpia(1:floor(L_b/2)+1); P1_limpia(2:end-1) = 2*P1_limpia(2:end-1);
P1_filt = abs(fft(y_bilineal)/L_b); P1_filt = P1_filt(1:floor(L_b/2)+1); P1_filt(2:end-1) = 2*P1_filt(2:end-1);

figure;
plot(f_eje_b, P1_ruido, 'r', 'LineWidth', 1.5); hold on;
plot(f_eje_b, P1_limpia, 'b', 'LineWidth', 1.5);
plot(f_eje_b, P1_filt, 'g--', 'LineWidth', 2.5);
title('Espectro de Frecuencias (Filtro Bilineal)');
xlabel('Frecuencia (Hz)'); ylabel('Amplitud');
legend('yb', 'yb\_sinruido', 'Filtrada');
xlim([0 0.5]); grid on;

figure;
[m, f_bode, w] = dbode(b, a, Tb);
m_db = 20 * log10(m);
semilogx(w, m_db, 'LineWidth', 2);
title('Diagrama de Bode - Filtro Bilineal');
xlabel('Frecuencia (rad/s)'); ylabel('Magnitud (dB)');
grid on;