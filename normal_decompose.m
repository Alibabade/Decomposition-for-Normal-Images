%% perform the normal decompose operation 
function [detail_img] = normal_decompose(img_filename, img_smooth_filename, img_detail_filename)
% input argument:
%                 img_filename -- original normal image ( h, w, c) included file path
%          img_smooth_filename -- the result of smoothed original normal image included file path
%         img_detaiil_filename -- the output filename included file path
% output:
%                   detail_img -- image with normal vectors (h, w, c)

% img= im2double(imread('amdo_high512_normal.png'));img_smooth = im2double(imread('amdo_high512_normal_s.png'));

%read images 
img = im2double(imread(img_filename));
img_smooth = im2double(imread(img_smooth_filename));
% previous normal image are normlized to [0,1];
% we need to convert the normal back to [-1,1];
img = 2* img -1; img_smooth = img_smooth * 2 -1;

tic;
[h,w,c] = size(img);
%convert [h,w,c] to [h*w,c]
img_normal_vector = reshape(img,[h*w,c]);
smooth_normal_vector = reshape(img_smooth,[h*w,c]);


% perform the normal minus operation
detail_normal_vector = normal_minus(img_normal_vector, smooth_normal_vector);


% extract the last three elements as x,y,z values in RGB format
detail_normal_vector = detail_normal_vector(:,2:4);

% convert computed normal interval from [1-,1] back to [0,1] for save. 
detail_normal_vector = detail_normal_vector *0.5 + 0.5;

% convert [h*w,c] back to [h,w,c]
detail_img = reshape(detail_normal_vector,[h,w,c]);

toc;

%normaliza the data and display
% detail_normaliza = ( detail_img - min(detail_img(:))  ) / ( max(detail_img(:)) - min(detail_img(:))  );
imwrite(detail_img, img_detail_filename);


end


%% perform the normal minus operation by considering normal difference
function [N_p] = normal_minus (vector_n1, vector_n2)
 % works for matrix operation
 % equation: n1 - n2 = quaternion(n2,n0).*N1.*inverse_quaternion(n2,n0)
 [h,w] = size(vector_n1);
 
 N1 = [zeros(h,1), vector_n1];
 vector_n0 = [0 0 1]; % a constant vertor
 quaternion = zeros(h,4);
 inverse_quaternion = zeros(h,4);
 % parallel for-loops using 'parfor' which accelerates speed
 parfor i = 1 : h 
   [quaternion(i,:), inverse_quaternion(i,:)] = calculation_quaternion(vector_n2(i,:), vector_n0);
 end
 % N_p = Q * P * Q^(-1) means rotate vector P according to Q  
 N_p = quatmultiply(quatmultiply(quaternion, N1),inverse_quaternion);

 
end

% calculate the rotation matrix from vector a to vector b via z-axis
% calculate the quanternion and inverse quaternion from ratation matrix

function [quaternion, inverse_quaternion] = calculation_quaternion(vector_a, vector_b)
    if all(vector_a ==0)
        vector_a = [0 0 1];
        % calculate the rotation from vector a to vector b
        r = vrrotvec(vector_a, vector_b);
        % calculate the rotation matrix
        m = vrrotvec2mat(r);
        % calculate the quaternion
        quaternion = rotm2quat(m);
        % calculate the inverse quaternion
        inverse_quaternion = quatinv(quaternion);
        
    else 
    r = vrrotvec(vector_a, vector_b);
    m = vrrotvec2mat(r);
    quaternion = rotm2quat(m);
    inverse_quaternion = quatinv(quaternion);
    end
end
