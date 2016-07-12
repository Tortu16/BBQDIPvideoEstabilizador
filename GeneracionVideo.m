%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Construccion del video inestable
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

% Definicion de variables aleatorias de desestabilizacion
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

 % Definicion de las caracteristicas estadisticas del ruido
 
 var_theta = 1;
 var_tx = 1;
 var_ty = 1;
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %
 %       Construccion del video 
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

% % Imagen de referencia
% filename = 'pout.tif';
% inputImage = imread(filename);
% info = imfinfo(filename);
%  
%  vid_Duration = 5; %5s
%  frames = vid_Duration*30; % 30 fps.
%  
%  % Inicializacion de la pila de imagenes que se convierten a v?deo
%  RGB = cat (3, inputImage, inputImage ,inputImage);
%  f(frames) = im2frame(RGB);
%  
%  % La imagen se distorciona aleatoriamente en cada cuadro
%  % El video se compone de la secuencia de imagenes deformadas
%  inputsize = size(inputImage);

v = VideoReader('xylophone.mp4');
s = struct('cdata',zeros(240,320,3,'uint8'),'colormap',[]);
k=1;
while hasFrame(v)
    s(k).cdata = readFrame(v);
    k = k+1;
end
whos s
close
%movie(s)
s2 = size(s);
frames = s2(2); 
inputsize = size(s(1).cdata)

 for n = 1:frames
     
    inputImage = s(n).cdata;
     
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Recorte de imagen
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    center = round(inputsize/2);
    center2 = round(inputsize/4);
    outputImage = imcrop(outputImage, [center(1)-100,center(2)-150,280, 200]);
    
    % Convierte cuadro a imagen RGB
    
    %RGB = cat (3, outputImage, outputImage ,outputImage);
    RGB = outputImage; %Cuando se importa un video, ya esta en RGB
    % Agrega cuadro a pila de imagenes que conforman el video.
    
    f(n) = im2frame (RGB);
 end
 
 % Reproduccion del video
 %movie(f)
 
 % Exporta el video a un archivo
 
v = VideoWriter('movideo.avi');
open (v);
for n = 1:frames
    writeVideo(v,f(n));
end
 close (v);
