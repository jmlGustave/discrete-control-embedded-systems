load 36290_datos_T-A.mat 

% Coeficientes de la planta (Modelo Identificado)
a1 = 1.3913; 
a2 = 0.5655; 
a3 = 0.0714;

b2 = 1.2331; 
b3 = 1.7692; 
b4 = 0.6315;

% Parámetros del Controlador y Simulación
Ku = 0.7385; 
N = 150; 

% Inicialización de vectores (cajas vacías de memoria)
y = zeros(N, 1); % Salida del sistema
u = zeros(N, 1); % Acción de control
e = zeros(N, 1); % Error
r = 2 * ones(N, 1); % Referencia (Escalón de amplitud 2)

% Vector de tiempo (T se ha cargado con el .mat)
t_sim = (0:N-1)' * T; 

% Bucle de simulación (Empieza en 5 para evitar índices negativos o cero)
for k = 5:N
    % Ecuación de la planta (calcula la salida actual)
    y(k) = -a1*y(k-1) - a2*y(k-2) - a3*y(k-3) + b2*u(k-2) + b3*u(k-3) + b4*u(k-4);
       
    % Cálculo del error actual
    e(k) = r(k) - y(k);
    
    % Ley de control (Controlador Proporcional calcula la nueva acción)
    u(k) = Ku * e(k);
end

% Gráfica de la respuesta
figure;
plot(t_sim, y, 'b', 'LineWidth', 1.5); hold on;
plot(t_sim, r, 'r--', 'LineWidth', 1.5);
title(['Respuesta en Lazo Cerrado con Ku = ', num2str(Ku)]);
xlabel('Tiempo (s)'); 
ylabel('Amplitud');
legend('Salida del sistema (y)', 'Referencia escalón (r)', 'Location', 'best');
grid on;