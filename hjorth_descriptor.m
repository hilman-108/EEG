function [activity, mobility, complexity] = hjorth_descriptor(x)
    % x : sinyal input, vektor 1 dimensi
    
    N = length(x);  % panjang sinyal
    
    % Orde pertama: diferensial pertama
    d = diff(x);  
    
    % Orde kedua: diferensial dari d(n)
    g = diff(d);  
    
    % Pastikan panjang sinyal untuk sigma_0, sigma_1, sigma_2
    sigma_0 = sqrt(sum(x.^2) / N);
    sigma_1 = sqrt(sum(d.^2) / length(d));  % panjang d = N - 1
    sigma_2 = sqrt(sum(g.^2) / length(g));  % panjang g = N - 2
    
    % Hitung Hjorth Parameters
    activity = sigma_0^2;
    mobility = (sigma_1^2) / (sigma_0^2);
    complexity = sqrt((sigma_2^2 / sigma_1^2) - (sigma_1^2 / sigma_0^2));
end