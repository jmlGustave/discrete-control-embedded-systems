% 1. Cargamos los datos
load 36290_datos_T-A.mat
ux = ux(:); yx = yx(:);

% 2. Identificación del modelo
na = 3; 
nb = 3; 
d = 2; 
H = 0;  
theta = identificacion(yx, ux, na, nb, d, H);

% 3. Construir los polinomios A y B
A = [1, theta(1:na)'];
B = [zeros(1, d), theta(na+1 : end)']; 

u_escalon = 2 * ones(length(tt), 1); 
N = length(u_escalon);

% Añadimos 4 ceros al principio para simular el "pasado" antes del inicio.
u_pad = [zeros(4, 1); u_escalon];
y_pad = zeros(N + 4, 1); % Vector de salida 4 casillas más grande

% Coeficientes
a1 = A(2); a2 = A(3); a3 = A(4);
b2 = B(3); b3 = B(4); b4 = B(5);

% Bucle para todos los instantes
for k = 5 : N + 4
    
    parte_entrada = b2*u_pad(k-2) + b3*u_pad(k-3) + b4*u_pad(k-4);
    
    parte_salida_pasada = a1*y_pad(k-1) + a2*y_pad(k-2) + a3*y_pad(k-3);
    
    y_pad(k) = parte_entrada - parte_salida_pasada;
end

% Quita los 4 ceros iniciales
salida_simulada = y_pad(5:end);

openfig('36290_respuesta_ante_escalon.fig'); 
hold on; 
plot(tt, salida_simulada, 'g--', 'LineWidth', 2);
legend('Salida Real (yx)', 'Entrada escalón (ux)', 'Salida de mi Modelo (Manual)');
grid on;