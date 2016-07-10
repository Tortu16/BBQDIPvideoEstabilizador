%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Construcción del vídeo inestable
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

% Imagen de referencia
filename = 'pout.tif';
inputImage = imread(filename);
info = imfinfo(filename);

% Definición de variables aleatorias de desestabilización
theta = 0;
phi = 0;
tx = 0;
ty = 0;
R_theta = [cosd(theta) -sind(theta);
           sind(theta)  cosd(theta)];
R_phi =   [cosd(phi) -sind(phi);
           sind(phi)  cosd(phi)]; 
R_mphi =   [cosd(-phi) -sind(-phi);
           sind(-phi)  cosd(-phi)]; 
lambda1 = 0;
lambda2 = 0;
D = [lambda1 0;0 lambda2];
A = R_theta*R_mphi*D*R_phi;
m = [A(1,1) A(1,2) tx; 
     A(2,1) A(2,2) ty; 
     0      0      1];

 % Definición de las características estadísticas del ruido
 
 var_theta = 1;
 var_tx = 1;
 var_ty = 1;
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %
 %       Construcción del vídeo 
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 vid_Duration = 5; %5s
 frames = vid_Duration*30; % 30 fps.
 
 % Inicialización de la pila de imágenes que se convierten a vídeo
 RGB = cat (3, inputImage, inputImage ,inputImage);
 f(frames) = im2frame(RGB);
 
 % La imágen se distorciona aleatoriamente en cada cuadro
 % El vídeo se compone de la secuencia de imágenes deformadas
 
 for n = 1:frames
    theta = var_theta * randn;
    tx = var_tx * randn;
    ty = var_ty * randn;
    R_theta = [cosd(theta) -sind(theta);
               sind(theta)  cosd(theta)];
    R_phi =   [cosd(phi) -sind(phi);
               sind(phi)  cosd(phi)]; 
    R_mphi =   [cosd(-phi) -sind(-phi);
               sind(-phi)  cosd(-phi)]; 
    lambda1 = 0.01*randn+1;
	lambda2 = 0.01*randn+1;
    D = [lambda1 0;0 lambda2];
    A = R_theta*R_mphi*D*R_phi;
    m = [A(1,1) A(2,1) 0; 
         A(1,2) A(2,2) 0; 
         tx      ty    1];
    tform = affine2d(m);
    outputImage = imwarp(inputImage,tform);
    %%%%%%%%%%%%%%
    %
    % Crops image
    %
    %%%%%%%%%%%%%%
    center = round(size(outputImage)/2);
    outputImage = imcrop(outputImage, [center(1)-round(inputsize(1)/2-30)+1, center(2)-round(inputsize(2)/2-30)+1,inputsize(1)-100, inputsize(2)-60]);
    
    % Turns frame to an RGB image
    RGB = cat (3, outputImage, outputImage ,outputImage);
    % Adds frame to image stack for later conversion to video.
    f(n) = im2frame (RGB);
 end
 
 % Reproducción del vídeo
 movie(f)
 
 v = VideoWriter('test.avi');
open (v);
for n = 1:frames
    writeVideo(v,f(n));
end
 close (v);


