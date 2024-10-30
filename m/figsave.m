function figsave(basename)
%FIGSAVE

fpath = fileparts(basename);
if ~isempty(fpath) && ~exist(fpath,'dir')
    mkdir(fpath);
    fprintf('Created directory %s\n',fpath);
end

fprintf('Writing %s.{png,pdf}\n',basename);
exportgraphics(gcf,[basename,'.png'],'Resolution',300);
exportgraphics(gcf,[basename,'.pdf'],'ContentType','vector');
fprintf('Wrote %s.{png,pdf}\n',basename);
