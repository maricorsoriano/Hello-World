n = camopen(0);
im = camread(n);
imshow(im);
J = imcropm(im);
scf(1);
imshow(J);


function [rint,gint]=ncc(im_input)
//This function transforms a true color image into its normalized chromaticity 
//coordinate equivalent
    I = double(im_input); 
    R = I(:,:,1); G = I(:,:,2); B = I(:,:,3);
    Int= R + G + B;
    Int(find(Int==0))=100000;
    r = R./ Int; g = G./Int;
    BINS = 32; // The number of bins can be changed. It converts the range of r-g from
    //0 to 1 to 0 to BINS.
    rint = round( r*(BINS-1) + 1);
    gint = round (g*(BINS-1) + 1);    
endfunction

[rint,gint] = ncc(J);
BINS = 32;

//---------Create color histogram
colors = gint(:) + (rint(:)-1)*BINS;
hist = zeros(BINS,BINS);
for row = 1:BINS
for col = 1:(BINS-row+1)
hist(row,col) = length( find(colors==( ((col + (row-1)*BINS)))));
end;
end;
histline =hist(:);
//imshow(mat2gray(hist));
//pause;

scf(2)
for i = 1:1000

im = camread(n);

// ------------Faster histogram backprojection;
clear rint gint;
[rint,gint]=ncc(im)
tic();
rintline = rint(:); gintline = gint(:);
Y = histline(int32(double(gintline-1)*BINS +double(rintline)));
fezlak = matrix(Y, size(rint));
imshow(mat2gray(fezlak))
t3=toc()

end;


avicloseall();
