function [t,r,v] = trajectory(conf,method)
    
r = conf.ro;
v = conf.vo;
tend = conf.tend;
B = conf.field;
q = conf.parameters.q;
m = conf.parameters.m;
Bo = conf.parameters.Bo;
RE = conf.parameters.RE;

if strcmp(method,'fe')
    % Forward Euler
    dt = 0.01*norm(v)*norm(B(r)); % Make dt a fraction of initial |v|*|B|
    dt = min(dt, norm(v));
    dt
    dt = 0.01;
    i = 1;
    t(1,1) = 0;
    %fprintf('t\tx\ty\n')
    while 1
        field = Bo*RE^3*B(r(i,:));
        %fprintf('%.8f  ',[t(i),r(i,:),v(i,:),field]);
        %fprintf('\n');
        v(i+1,:) = v(i,:) + dt*cross(v(i,:), field);
        r(i+1,:) = r(i,:) + dt*v(i,:);
        t(i+1,1) = t(i,1) + dt;
        if t(i+1,1) >= tend
            break
        end
        i = i + 1;
    end
    return
end

%% Runge-Kutta

function ret = dXdt(t, X)
    vxB = cross(X(4:6), B(X(1:3)))';
    ret = [X(4:6); vxB];
end
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
[t, X] = ode45(@dXdt, [0, tend], [r, v], opts);
r = X(:,1:3);
v = X(:,4:6);

end