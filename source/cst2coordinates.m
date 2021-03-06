function coord = cst2coordinates(x)
%CST2COORDINATES Summary of this function goes here
%   Detailed explanation goes here

    size = numel(x);
    coord = CST_airfoil(x(1:size/2),x(size/2+1:size),0,30);

end

function [coord] = CST_airfoil(wl,wu,dz,N)

% Description : Create a set of airfoil coordinates using CST parametrization method 
% Input  : wl = CST weight of lower surface
%          wu = CST weight of upper surface
%          dz = trailing edge thickness
% Output : coord = set of x-y coordinates of airfoil generated by CST


% Create x coordinate
x=ones(N+1,1);
y=zeros(N+1,1);
zeta=zeros(N+1,1);

for i=1:N+1
    zeta(i)=2*pi/N*(i-1);
    x(i)=0.5*(cos(zeta(i))+1);
end

% N1 and N2 parameters (N1 = 0.5 and N2 = 1 for airfoil shape)
N1 = 0.5;
N2 = 1;

[~,zerind] = min(x(:,1)); % Used to separate upper and lower surfaces

xl = x(1:zerind-1); % Lower surface x-coordinates
xu = x(zerind:end); % Upper surface x-coordinates

[yl] = ClassShape(wl,xl,N1,N2,-dz); % Call ClassShape function to determine lower surface y-coordinates
[yu] = ClassShape(wu,xu,N1,N2,dz);  % Call ClassShape function to determine upper surface y-coordinates

y = [yl;yu]; % Combine upper and lower y coordinates

coord = [x y]; % Combine x and y into single output

end

%% Function to calculate class and shape function
function [y] = ClassShape(w,x,N1,N2,dz)


% Class function; taking input of N1 and N2
C(:,1) = x(:).^N1.*((1-x(:)).^N2);


% Shape function; using Bernstein Polynomials
n = length(w)-1; % Order of Bernstein polynomials

K(n+1) = 0;
for i = 1:n+1
     K(i) = factorial(n)/(factorial(i-1)*(factorial((n)-(i-1))));
end

S(length(x),1) = 0;
for j = 1:n+1
        S(:,1) = S(:,1) + w(j)*K(j)*x(:).^(j-1).*((1-x(:)).^(n-(j-1)));
end

% Calculate y output
y(:,1) = C(:,1).*S(:,1) + x(:)*dz;


end
