function [smooth_result] = Smoothing(img_filename, sigma_s, sigma_r)

  I = im2double(imread(img_filename));
  % apply RF: Domain Transform Recursive edge-perserving filter
  smooth_result = RF(I,sigma_s, sigma_r);
 
  output_filename = [img_filename(1:end-4),'_', num2str(sigma_s),'_', num2str(sigma_r),'_s.png'] ;
  imwrite(smooth_result, output_filename);

end
