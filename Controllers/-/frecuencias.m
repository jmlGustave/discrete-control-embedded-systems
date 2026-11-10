% --- 1. CONFIGURACIÓN INICIAL ---
% Calculamos la frecuencia de muestreo (Fs) a partir del periodo (Tb)
Fs = 1 / Tb; 
L = length(yb); % Longitud de la señal

% Creamos el eje de frecuencias (eje X en Hz)
f = Fs * (0:floor(L/2)) / L;

% --- 2. FFT DE LA SEÑAL CON RUIDO (yb) ---
Y_ruido = fft(yb);
P2_ruido = abs(Y_ruido / L);
P1_ruido = P2_ruido(1:floor(L/2)+1);
P1_ruido(2:end-1) = 2 * P1_ruido(2:end-1);

% --- 3. FFT DE LA SEÑAL LIMPIA (yb_sinruido) ---
Y_limpia = fft(yb_sinruido);
P2_limpia = abs(Y_limpia / L);
P1_limpia = P2_limpia(1:floor(L/2)+1);
P1_limpia(2:end-1) = 2 * P1_limpia(2:end-1);

% --- 4. DIBUJAMOS LA GRÁFICA COMPARATIVA ---
figure;
% Dibujamos la ruidosa en rojo (para que destaquen los picos malos)
plot(f, P1_ruido, 'r', 'LineWidth', 1.5); hold on;
% Dibujamos la limpia en azul por encima
plot(f, P1_limpia, 'b', 'LineWidth', 1.5);

title('Espectro de Frecuencias: yb (ruido) vs yb\_sinruido (limpio)');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');
legend('yb (Con Ruido)', 'yb\_sinruido (Limpia)');
grid on;