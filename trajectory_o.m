clear
dt = 1e-6;
i = 1;
t(1,1) = 0;
RE = 6378e3; % meter
m  = 1.67262192e-27; % kilogram
q = 1.602e-19; % Coulomb
r = [RE,0,0];
v = [1e7,0,0];

for i = 1:20000
    field = dipole(r(i,:));
    fprintf('%.8f  ',[t(i),r(i,:),v(i,:),field]);
    fprintf('\n');
    v(i+1,:) = v(i,:) + (q/m)*dt*cross(v(i,:),field);
    r(i+1,:) = r(i,:) + dt*v(i,:);
    t(i+1,1) = t(i,1) + dt;
end
figure(1);clf;
plot(r(:,1),r(:,2))
xlabel('x')
ylabel('y')

function f = dipole(r)
    Bo = 3e-5;   % Tesla
    RE = 6378e3; % meter

    % In cartesian
    %   B = (2*cos(theta)*r_hat + sin(theta)*theta_hat)/r^3
    % is
    %   B = (1/r^5) * (3*x*z*x_hat + 3*y*z*y_hat + (3*z^2 - r^2)*z_hat)

    if size(r,2) == 1
        r = r';
    end
    r2 = r(:,1).^2 + r(:,2).^2 + r(:,3)^2;
    r5 = sqrt(r2).^5;
    fx = (3*r(:,1)*r(:,3))./r5;
    fy = (3*r(:,2)*r(:,3))./r5;
    fz = (3*r(:,3)^2 - r2)./r5;
    %f = [0, 0, -r(1)];
    f = Bo*RE^3*[fx, fy, fz];
    %f = [0, 0, -Bo];
end