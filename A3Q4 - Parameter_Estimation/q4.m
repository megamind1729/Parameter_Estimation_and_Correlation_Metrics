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
N = 250;
m = (V*V');
LL = zeros(1,11);
V = T;
N = 750;
x = -8:0.1:8;

sigma = [0.001, 0.1, 0.2, 0.9, 1, 2, 3, 5, 10, 20, 100];

for i = 1:11
    LL(i) = 1;
    for j = 1:N
        LL(i) = LL(i)+log(p_n_x(V(j), T, sigma(i)));
    end
end

[maxima, index] = max(LL);
sigma_best = sigma(index)


p_N_x = zeros(1,161);
real_gaussian = zeros(1, 161);
for i = 1:161
    p_N_x(i) = p_n_x(x(i), T, sigma_best);
    real_gaussian(i) = p(x(i));
end 


figure;
plot(log(sigma)/log(10), LL, '-o');
% Add labels and title
xlabel('X-Axis');
ylabel('Y-Axis');
title('LL vs log_sigma');

figure;
plot(x, p_N_x, 'b');
hold on;
plot(x, real_gaussian, 'r');


D = zeros(1,11);
for j = 1:11
    temp1 = zeros(1,161);
    temp2 = zeros(1,161);
    for i = 1:N
        temp1(i) = p_n_x(V(i), x, sigma(j));
        temp2(i) = p(V(i));
    end
    temp3 = (temp1 - temp2).*(temp1 - temp2);
    D(j) = sum(temp3(:));
end

[maxima, index] = min(D);
sigma_new_best = sigma(index)


p_N_x = zeros(1,161);
real_gaussian = zeros(1, 161);
for i = 1:161
    p_N_x(i) = p_n_x(x(i), T, sigma_new_best);
    real_gaussian(i) = p(x(i));
end 

figure;
plot(log(sigma)/log(10), D, '-o');
% Add labels and title
xlabel('X-Axis');
ylabel('Y-Axis');
title('D vs log_sigma');

figure;
plot(x, p_N_x, 'b');
hold on;
plot(x, real_gaussian, 'r');


function p_n = p_n_x(x, V, sigma_best)
    arr = exp(-(x - V).*(x - V)/(2*sigma_best*sigma_best));
    p_n = sum(arr(:))/(size(V,2)*sigma_best*sqrt(2*pi));
end

function prob = p(x)
    sigma = 4;
    prob = exp(-x*x/(2*sigma*sigma))/(sigma*sqrt(2*pi));
end