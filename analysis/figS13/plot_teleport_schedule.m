df_list = dir('./data/*.mat');
for i = 1:size(df_list, 1)
    df = df_list(i).name;
    [~, df_name, df_ext] = fileparts(df);
    fprintf('Processing %s\n', df_name);
    plot_teleport(...
        ['./data' filesep df_name df_ext], ...
        ['./figures' filesep df_name] ...
    );
end