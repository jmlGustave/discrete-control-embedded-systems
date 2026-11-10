
load 36290_datos_T-A.mat

a1 = 1.3913; a2 = 0.5655; a3 = 0.0714;
b2 = 1.2331; b3 = 1.7692; b4 = 0.6315;

Ku = 0.7385;
Tu = 0.4;
Escalon = 2; 

% Parametros del PID
Kc = 0.61 * Ku;
Ti = 0.5 * Tu;   % Corregido: Ti es 1/2 de Tu
Td = 0.125 * Tu; % Corregido: Td es 1/8 de Tu

% Constantes de la ecuación en diferencias del PID
c0 = Kc * (1 + (Td/T));
c1 = Kc * (-1 + (T/Ti) - (2*Td/T));
c2 = Kc * (Td/T);

% ini vectores
N = 150; % Número de muestras a simular
y = zeros(N, 1);
u = zeros(N, 1);
error = zeros(N, 1);
t = zeros(N, 1);

% Bucle de simulacion
for k = 5:N
    
    % Tiempo actual
    t(k) = (k-1) * T;
    
    y(k) = -a1*y(k-1) - a2*y(k-2) - a3*y(k-3) + b2*u(k-2) + b3*u(k-3) + b4*u(k-4);
       
    % Calculo del error
    error(k) = Escalon - y(k);
        
    % d) Controlador PID: Calculamos la acción de control u(k)
    u(k) = u(k-1) + c0*error(k) + c1*error(k-1) + c2*error(k-2);
    
    if u(k) > 10
        u(k) = 10;
    elseif u(k) < 0
        u(k) = 0;
    end
    
end

% Grafica
figure;
plot(t, y, 'b', 'LineWidth', 1.5); hold on;
yline(Escalon, 'r--', 'LineWidth', 1.5); 
title('Salida del Sistema (y)'); 
xlabel('Tiempo (s)'); ylabel('Amplitud');
grid on;

figure;
plot(t, u, 'r', 'LineWidth', 1.5);
title('Acción de Control (u)'); 
xlabel('Tiempo (s)'); ylabel('Amplitud');
grid on;
