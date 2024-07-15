% Load the grayscale images
I1 = double(imread('T1.jpg'));
I2 = double(imread('T2.jpg'));

% Define the shift amount in pixels
n = -10:1:10; % Shift by 20 pixels along the x-axis

correlation_coefficient_arr = zeros(1, 21);
QMI = zeros(1, 21);

% Get the size of the image
[rows, cols] = size(I1);
alpha = 1;
for tx = n
    % Create a new image to store the shifted result as a double
    shifted_I2 = zeros(rows, cols);
    
    % Shift the grayscale image along the x-axis
    for i = 1:rows
        for j = 1:cols
            % Calculate the new x-coordinate with the shift
            new_x = j + tx;
            
            % Ensure the new_x is within the valid range
            if new_x >= 1 && new_x <= cols
                shifted_I2(i, new_x) = I2(i, j);
            end
        end
    end
    
    correlation_coefficient = corr2(I1, shifted_I2);
    
    joint_pmf = zeros(26, 26);
    
    for i = 1:rows
        for j = 1:cols
            k = fix(I1(i, j)/10)+1;
            l = fix(shifted_I2(i, j)/10)+1;
            joint_pmf(k,l) = joint_pmf(k,l) + 1;
        end
    end
    joint_pmf = joint_pmf/(rows*cols);
    pmfX = sum(joint_pmf, 1);
    pmfY = sum(joint_pmf, 2);
    pmf = pmfY*pmfX;
    square_diff = (joint_pmf - pmf).^2;
    QMI(alpha) = sum(square_diff(:));
    correlation_coefficient_arr(alpha) = correlation_coefficient;
    alpha = alpha+1;
end

figure;
plot(n, QMI);
xlabel("Shift(t_{x})");
ylabel("QMI");
title("QMI vs t_{x}");

figure;
plot(n, correlation_coefficient_arr);
xlabel("Shift (t_{x})");
ylabel("Correlation coefficient");
title("Correlation Coefficient vs t_{x}");

I2_new = 255 - I1;

n = -10:1:10; % Shift by 20 pixels along the x-axis

correlation_coefficient_arr = zeros(1, 21);
QMI = zeros(1, 21);
alpha = 1;
for tx = n
    % Create a new image to store the shifted result as a double
    shifted_I2_new = zeros(rows, cols);
    
    % Shift the grayscale image along the x-axis
    for i = 1:rows
        for j = 1:cols
            % Calculate the new x-coordinate with the shift
            new_x = j + tx;
            
            % Ensure the new_x is within the valid range
            if new_x >= 1 && new_x <= cols
                shifted_I2_new(i, new_x) = I2_new(i, j);
            end
        end
    end

    % Finding correlation coefficient between I1 and shifted_I2_new
    correlation_coefficient = corr2(I1, shifted_I2_new);
    
    joint_pmf = zeros(26, 26);
    
    for i = 1:rows
        for j = 1:cols
            k = fix(I1(i, j)/10)+1;
            l = fix(shifted_I2_new(i, j)/10)+1;
            joint_pmf(k,l) = joint_pmf(k,l) + 1;
        end
    end
    joint_pmf = joint_pmf/(rows*cols);
    pmfX = sum(joint_pmf, 1);
    pmfY = sum(joint_pmf, 2);
    pmf = pmfY*pmfX;
    square_diff = (joint_pmf - pmf).^2;
    QMI(alpha) = sum(square_diff(:));
    correlation_coefficient_arr(alpha) = correlation_coefficient;
    alpha = alpha+1;
end

figure;
plot(n, QMI);
xlabel("Shift (t_{x})");
ylabel("QMI ");
title("QMI vs tx");

figure;
plot(n, correlation_coefficient_arr);
xlabel("Shift (t_{x})");
ylabel("Correlation coefficient");
title("Correlation Coefficient vs t_{x}");

