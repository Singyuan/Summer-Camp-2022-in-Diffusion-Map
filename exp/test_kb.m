clc; clear; close all;
n = 5000;
u = rand(n, 1)*2*pi;
v = rand(n, 1)*pi;



x = -2/15*cos(u).*(3*cos(v)-30*sin(u)+90*cos(u).^4.*sin(u)-60*cos(u).^6.*sin(u)+5*cos(u).*cos(v).*sin(u));
y = -1/15*sin(u).*(3*cos(v)-3*cos(u).^2.*cos(v)-48*cos(u).^4.*cos(v)+48*cos(u).^6.*cos(v)-60*sin(u)+5*cos(u).*cos(v).*sin(u)-5*cos(u).^3.*cos(v).*sin(u)-80*cos(u).^5.*cos(v).*sin(u)+80*cos(u).^7.*cos(v).*sin(u));
z = 2/15*(3+5*cos(u).*sin(u).*sin(v));
plot3(x,y,z, '.')
