% run.sh in matlab

% parameters for Smoothing function
sigma_s = 100;
sigma_r = 0.7;
% filename for input normal image
filename = './data/normal_black';

% smooth the input normal image
Smoothing([filename,'.png'], sigma_s, sigma_r); 
% process normal decompose
normal_decompose([filename, '.png'], ...
                 [filename, '_', num2str(sigma_s),'_', num2str(sigma_r), '_s.png'],...                   
                 [filename, '_', num2str(sigma_s),'_', num2str(sigma_r), '_d.png']);
                
