function theta = identificacion(y, u, na, nb, d, H)
    % N es el último elemento de los vectores
    N = length(y); 
    
    % Cálculo del instante M para descartar los primeros H elementos
    M = H + 1 + max(na, nb - 1 + d); 
    
    % Inicialización de la matriz de regresores (phi) y vector de salida (Y)
    phi = zeros(N - M + 1, na + nb);
    Y = y(M:N); 
    
    % Construcción de la matriz phi fila a fila
    fila = 1;
    for k = M:N
        % Valores pasados de la salida y la entrada
        y_ant = -y(k-1 : -1 : k-na);
        u_ant = u(k-d : -1 : k-d-nb+1);
        
        phi(fila, :) = [y_ant', u_ant'];
        fila = fila + 1;
    end
    
    % Ecuación de Mínimos Cuadrados para estimar los parámetros
    theta = inv(phi' * phi) * phi' * Y; 
end