function[res]=Energy(X)

GammaE=0.825;
Vdd=1;
Cmin=0.73;
Cload=50;
res=Cmin*Vdd*Vdd*(GammaE+(1+GammaE)*X(1)+(1+GammaE)*X(2)+Cload);
%l'energia risultante sarà espressa in fJ