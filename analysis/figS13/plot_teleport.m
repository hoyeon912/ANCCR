function [] = plot_teleport()
    df = './data/figS13/ramping_teleport.mat';
    d = load(df).archive;
    n_sim = numel(d);
    max_cue = max(d{1}.eventlog_pre(:, 1));
    n_trial = size(d{1}.eventlog_pre, 1) / max_cue * 2;
    dt = struct( ...
        'DA', nan([n_trial max_cue numel(d)]), ...
        'grp', nan([n_trial 1 numel(d)])); 
    
    for i = 1:n_sim
        log = [d{i}.eventlog_pre; d{i}.eventlog_post];
        [trial_on, reward_on, ~, grp] = util_process_data(log);
        for j = 1:n_trial
            len_trial = reward_on(j) - trial_on(j) + 1;
            dt.DA(j, 1:len_trial, i) = d{i}.DA(trial_on(j):reward_on(j));
            dt.grp(:, 1, i) = grp;
        end
    end
    
    n_ctrl = 0;
    for i = 1:n_sim
        n_ctrl = n_ctrl + find(dt.grp(:, 1, i) ~= 1, 1)-(n_trial/2+1);
    end

    n_tel = numel(unique(dt.grp))-1;
    tel_resp = nan([n_sim, max_cue, n_tel]);
    ctrl_resp = nan([n_ctrl, max_cue]);
    ctrl_iter = 1;
    for i = 1:n_sim
        for j = 1:n_tel
            tel_resp(i, :, j) = dt.DA(find(dt.grp(:, 1, i) == j*2, 1), :, i);
        end
        for j = 2001:(find(dt.grp(:, 1, i) ~= 1, 1)-1)
            ctrl_resp(ctrl_iter, :) = dt.DA(j, :, i);
            ctrl_iter = ctrl_iter + 1;
        end
    end
    assert( ...
        ctrl_iter > n_ctrl, ...
        sprintf( ...
            '# of control iterator(%d) is smaller than # of control(%d)', ...
            ctrl_iter, n_ctrl...
        ) ...
    );
   
    figure('Name', 'Figure 1. Predicted DA response aligned by trial on');
    t = sprintf(['Predicted DA response ab trial on\n' ...
        'n(teleport response) = %d, n(standard) = %d'], ...
        n_sim, n_ctrl ...
    );
    sgtitle(t);
    pos = get(gcf, 'Position');
    set(gcf, 'Position', pos + [0 0 600 0]);
    for i = 1:n_tel
        subplot(1, 3, i);
        errorbar(...
            mean(tel_resp(:, :, i)), ...
            2*std(tel_resp(:, :, i)), ...
            '-r' ...
        );
        hold on
        errorbar( ...
            mean(ctrl_resp), ...
            2*std(ctrl_resp), ...
            '-k' ...
        );
        xline( ...
            2*i, ...
            '-b' ...
        );
        lgd = legend({'1st teleport', 'Standard', 'Teleport point'});
        lgd.AutoUpdate = 'off';
        fill(...
            [1:max_cue-1 flip(1:max_cue-1)], ...
            [max(tel_resp(:,1:end-1,i)),flip(min(tel_resp(:,1:end-1,i)))],...
            'red', ...
            'EdgeColor', 'none', ...
            'FaceAlpha', 0.3...
        );
        fill(...
            [1:max_cue flip(1:max_cue)], ...
            [max(ctrl_resp), flip(min(ctrl_resp))], ...
            'black', ...
            'EdgeColor', 'none', ...
            'FaceAlpha', 0.3...
        );
        hold off
        title(sprintf('Teleport @ cue %d', 2*i-1));
        xlabel('Cue');
        ylabel('DA');
        xticks(1:max_cue);
    end
    saveas(gcf,'./fig/figS13_1-teleport_response_ab_trial_on.png');

    figure('Name', 'Figure 2. Predicted DA response aligned by reward on');
    t = sprintf(['Predicted DA response ab reward on\n' ...
        'n(teleport response) = %d, n(standard) = %d'], ...
        n_sim, n_ctrl ...
    );
    sgtitle(t);    pos = get(gcf, 'Position');
    set(gcf, 'Position', pos + [0 0 600 0]);
    for i = 1:n_tel
        subplot(1, 3, i);
        errorbar( ...
            2:max_cue, ...
            mean(tel_resp(:, 1:end-1, i)), ...
            2*std(tel_resp(:, 1:end-1, i)), ...
            '-r' ...
        );
        hold on
        errorbar( ...
            mean(ctrl_resp), ...
            2*std(ctrl_resp), ...
            '-k' ...
        );
        xline( ...
            2*i+1, ...
            '-b' ...
        );
        lgd = legend({'1st teleport', 'Standard', 'Teleport point'});
        lgd.AutoUpdate = 'off';
        fill(...
            [2:max_cue flip(2:max_cue)], ...
            [max(tel_resp(:,1:end-1,i)),flip(min(tel_resp(:,1:end-1,i)))],...
            'red', ...
            'EdgeColor', 'none', ...
            'FaceAlpha', 0.3...
        );
        fill(...
            [1:max_cue flip(1:max_cue)], ...
            [max(ctrl_resp), flip(min(ctrl_resp))], ...
            'black', ...
            'EdgeColor', 'none', ...
            'FaceAlpha', 0.3...
        );
        hold off
        title(sprintf('Teleport @ cue %d', 2*i-1));
        xlabel('Cue');
        ylabel('DA');
        xticks(1:max_cue);
    end
    saveas(gcf,'./fig/figS13_2-teleport_response_ab_reward_on.png');

    for i = 1:n_tel
        y = [tel_resp(:, 2*i, i)', ctrl_resp(:, 2*i)'];
        group = [ ...
            ones(flip(size(tel_resp(:, 2*i, i)))), ...
            2*ones(flip(size(ctrl_resp(:,2*i)))) ...
        ];
        [p, tbl] = anova1(y, group);
        t = sprintf(...
            'Teleport @ cue %d ab trial on\nANOVA F = %.4f, p = %.4f', ...
            2*i-1, tbl{2,5}, p ...
        );
        title(t);
        set(gcf, 'Name', 'Figure 3. ANOVA with response ab trial on');
        xticklabels({'Teleport', 'Standard'});
        fname = sprintf( ...
            './fig/figS13_3-%d-ANOVA_tel_cue_%d_ab_trial_on.png', ...
            i, 2*i-1 ...
        );
        saveas(gcf, fname);
    end

    for i = 1:n_tel
        y = [tel_resp(:, 2*i, i)', ctrl_resp(:, 2*i+1)'];
        group = [ ...
            ones(flip(size(tel_resp(:, 2*i, i)))), ...
            2*ones(flip(size(ctrl_resp(:,2*i+1)))) ...
        ];
        [p, tbl] = anova1(y, group);
        t = sprintf(...
            'Teleport @ cue %d ab reward on\nANOVA F = %.4f, p = %.4f', ...
            2*i-1, tbl{2,5}, p ...
        );
        title(t);
        set(gcf, 'Name', 'Figure 3. ANOVA with response ab reward on');
        xticklabels({'Teleport', 'Standard'});
        fname = sprintf( ...
            './fig/figS13_4-%d-ANOVA_tel_cue_%d_ab_reward_on.png', ...
            i, 2*i-1 ...
        );
        saveas(gcf, fname);
    end
end