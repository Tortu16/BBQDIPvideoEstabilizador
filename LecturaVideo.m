%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Lectura del video inestable
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


v = VideoReader('C:\Users\ljimenez\Documents\MATLAB\movideo.avi');
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
inputsize = size(s(1).cdata);

 for n = 1:frames
     
    inputImage = s(n).cdata;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %  Codigo que estabiliza opera sobre inputImage
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    outputImage = inputImage;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    RGB = outputImage; %Cuando se importa un video, ya esta en RGB
    % Agrega cuadro a pila de imagenes que conforman el video.
    
    f(n) = im2frame (RGB);
 end
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %
 %    Muestra el resultado
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 movie (f)
