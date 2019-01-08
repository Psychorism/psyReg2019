function z = BVN(x, y, muX, muY, sigma, rho)
    normX = (x-muX) / sigma;
    normY = (y-muY) / sigma;

    amplitude = 1 / (2 * pi * sigma^2 * sqrt(1 - rho^2) );
    exponent = (normX.^2 - 2*rho*(normX.*normY) + normY.^2)/(1-rho^2);
	z       = amplitude  * exp(-exponent/2);
end 
