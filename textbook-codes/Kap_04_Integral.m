%-- Kap_04_Integral.m
function Schieber
 format long;
 a=1.0; b=2.0;
 Int_1 = mein_trapez(@rohr,a,b)  %-- = 1.227958801100042
 Int_2 = integral(@rohr,a,b)     %-- = 1.228369698608757
 diff = abs(Int_1-Int_2)         %-- = 4.108975087147027e-04
end
 
function I = mein_trapez(fcn,a,b)
%-- zusammengesetzte Trapezregel mit 100 Teilintervallen
 n=100; h=(b-a)/n;
 sum=fcn(a)+fcn(b);
 x=a;
 for i=1:n-1
   x=x+h;
   sum=sum+2.0*fcn(x);
 end
 I = h*sum/2;
end

function f=rohr(x)
 f=sqrt(4-x.^2);
end