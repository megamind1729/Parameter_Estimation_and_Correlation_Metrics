clear;
clc;
rng("default");
% Parameters
mean_value = 0;
variance_value = 16;
num_points = 1000;

% Generate random data points following N(0, 1)
random_data = randn(1, num_points);

% Scale and shift to N(0, 16)
scaled_data = sqrt(variance_value) * random_data;

T = scaled_data(1:750);
V = scaled_data(751:1000);
V = T;
N = 750;
m = (V*V');
LL = zeros(1,11);
V = T;
N = 750;
x = -8:0.1:8;

sigma = [0.001, 0.1, 0.2, 0.9, 1, 2, 3, 5, 10, 20, 100];

% The term when p_n_x(V(i), x, sigma(j)) will overshoot when V(i) = x which
% is will happen if we set V = T. 
for i = 1:11
    LL(i) = 1;
    for j = 1:N
        LL(i) = LL(i)+log(p_n_x(V(j), T, sigma(i)));
    end
end

[maxima, index] = max(LL);
sigma_best = sigma(index)

% This is the code in which we are not evaluating p_n_x if V(i) = x. Here
% the modified function p_n_updated_x is used so it is providing values of
% sigma closer to our expectation so the modified cross-validation
% procedure is working. 

for i = 1:11
    LL(i) = 1;
    for j = 1:N
        LL(i) = LL(i)+log(p_n_updated_x(V(j), T, sigma(i)));
    end
end

[maxima, index] = max(LL);
sigma_best = sigma(index)

function p_n = p_n_x(x, V, sigma_best)
    arr = exp(-(x - V).*(x - V)/(2*sigma_best*sigma_best));
    p_n = sum(arr(:))/(size(V,2)*sigma_best*sqrt(2*pi));
end

function p_n = p_n_updated_x(x, V, sigma_best)
    arr = exp(-(x - V).*(x - V)/(2*sigma_best*sigma_best));
    p_n = (sum(arr(:)) - 1)/(size(V,2)*sigma_best*sqrt(2*pi));
end