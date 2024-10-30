% Solve
%   dv/dt = v x B
%   dr/dt = v
% where v, t, and B are dimensionless and related to given values by
%   B = B/Bo
%   t = t/tau; tau = 2*pi*m/(q*Bo)
%   v = v/vo
%   r = r/R_E

clear
figsave_ = 0;
cwd = fullfile(fileparts(mfilename('fullpath')));
addpath(cwd,'m');

conf = trajectory_conf(2);

method = {'fe', 'rk45'};
legend_ = {'Forward Euler', 'Runge-Kutta 4-5'};
method = method(2);
legend_ = legend_(2);
for m = 1:length(method)
    [t{m},r{m},v{m}] = trajectory(conf.ro,conf.vo,conf.tend,conf.field,method{m});
    E{m} = sum(v{m}.^2,2);
    %mu{m} = E{m}/norm(conf.field(r{m}));
    E{m} = E{m}/E{m}(1);
    %mu{m} = mu{m}/mu{m}(1);
end

f = 1;
for i = 1:3
  if all(r{m}(:,i) == 0)
      continue;
  end
  figprep(f);
  f = f + 1;
  
  for m = 1:length(method)
    plot(t{m},r{m}(:,i));
  end
  title(conf.title)
  legend(legend_);
  xlabel(conf.tlabel);
  ylabel(conf.rlabels{i});
  if figsave_
    figsave(fullfile(cwd,'figs',conf.dir,sprintf('%s_vs_t',conf.rfilelabels{i})));
  end
end

for i = 1:3
  if all(r{m}(:,i) == 0)
      continue;
  end
  figprep(f);
  f = f + 1;
  
  for m = 1:length(method)
    plot(t{m},v{m}(:,i));
  end
  title(conf.title)
  legend(legend_);
  xlabel(conf.tlabel);
  ylabel(conf.vlabels{i});
  if figsave_
      figsave(fullfile(cwd,'figs',conf.dir,sprintf('%s_vs_t',conf.vfilelabels{i})));
  end
end

figprep(f)
  for m = 1:length(method)
    plot(r{m}(:,1),r{m}(:,2));
  end
  axis square;
  set(gca,'XLim', [-1.5, 1.5])
  set(gca,'YLim', [-1.5, 1.5])
  legend(legend_);
  xlabel(conf.rlabels{1});
  ylabel(conf.rlabels{2});
  if figsave_
      fname = sprintf('%s_vs_%s',conf.xfilelabels{2},conf.xfilelabels{1});
      figsave(fullfile(cwd,'figs',conf.dir,fname));
  end

if 0  
figure(3)
  clf;figprep;hold on;grid on;
  for m = 1:length(method)
    plot(t{m},E{m});
  end
  legend(legend_);
  xlabel(conf.tlabel);
  ylabel('$E/E_o$');
  figsave(fullfile(cwd,'figs',conf.dir,'E_vs_t'));

figure(4)
  clf;figprep;hold on;grid on;
  for m = 1:length(method)
    plot(t{m},mu{m});
  end
  legend(legend_);
  xlabel(conf.tlabel);
  ylabel('$\mu/\mu_o$');
  figsave(fullfile(cwd,'figs',conf.dir,'mu_vs_t'));
end  
