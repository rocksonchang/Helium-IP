function matrixOut = IP_2DConv(matrixIn,Nr,Nc)
G = fspecial('gaussian',[round(3*Nr) round(3*Nr)],Nr);
matrixOut = imfilter(matrixIn,G,'same');