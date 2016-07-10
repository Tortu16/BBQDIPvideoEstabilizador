%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Construcci?n del v?deo inestable
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Imagen de referencia
filename = 'pout.tif';
A = imread(filename);
info = imfinfo(filename);

% Definici?n de variables aleatorias de desestabilizaci?n
theta = 0;
tx = 0;
ty = 0;
m = [cosd(theta) -sind(theta) 0; 
     sind(theta)  cosd(theta) 0; 
     tx           ty          1];

 % Definici?n de las caracter?sticas estad?sticas del ruido
 
 var_theta = 1;
 var_tx = 1;
 var_ty = 1;
 
 % Construcci?n del v?deo cuadro a cuadro
 
 for n = 1:150
    theta = var_theta * randn;
    tx = var_tx * randn;
    ty = var_ty * randn;
    m = [cosd(theta) -sind(theta) 0; 
         sind(theta)  cosd(theta) 0; 
         tx           ty          1];
    tform = affine2d(m);
    outputImage = imwarp(A,tform);
    RGB = cat (3, outputImage, outputImage ,outputImage);
    f(n) = im2frame (RGB);
 end
 
 % Reproducci?n del v?deo
 movie(f)


