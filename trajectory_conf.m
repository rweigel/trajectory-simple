function conf = trajectory_conf(c)

    Bo = 3e-5; % Tesla
    RE = 6378e3; % meter
    m  = 1.67262192e-27; % kilogram
    q = 1.602e-19; % Coulomb
    tau = m/(q*Bo)
    
    E = 1e7;
    %vox = sqrt((2*q/m)*E)
    vox = 1e7;
    ro = [RE, 0, 0];
    vo = [vox, 0, 0]; % m/s
    ro = ro/RE;
    %vo = vo/norm(vo)/10;
    vo = 100*vo/(RE/tau);
    tend = 10/tau;
    %tend = 2*pi*1000;
    %tend = 0.03;
    
    conf = struct();
    if c == 1
        conf.title = '$\mathbf{B}=-\hat{\mathbf{z}}$';
        conf.dir = 'const_Bz';
        conf.field = @const_Bz;
    end
    if c == 2
        conf.title = '$\mathbf{B}=(3xz\hat{\mathbf{x}} + 3yz\hat{\mathbf{y}} + (3z^2 - r^2)\hat{\mathbf{z}})/r^5$';
        conf.dir = 'dipole';
        conf.field = @dipole;
    end
    conf.ro = ro;
    conf.vo = vo;
    conf.tend = tend;
    conf.tau = tau;
    conf.tlabel = '$t/\tau$';
    conf.rlabels = {'$x/R_E$', '$y/R_E$', '$z/R_E$'};
    conf.rfilelabels = {'x','y','z'};
    conf.vlabels = {'$v_x$', '$v_y$', '$v_z$'};
    conf.vfilelabels = {'vx','vy','vz'};
end

function f = dipole(r)
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
    f = [fx, fy, fz];
end

function f = const_Bz(r)
    f = [0,0,-1];
end
