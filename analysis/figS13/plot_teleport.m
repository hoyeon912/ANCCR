function [] = plot_teleport(DA, trial_on, reward_on, teleport_on, grp)
    DA_in_trial = nan([size(trial_on, 1), 9]);
    for i = 1:size(trial_on, 1)
        trial_length = reward_on(i) - trial_on(i) + 1;
        DA_in_trial(i, 1:trial_length) = DA(trial_on(i):reward_on(i));
    end
    data = table(DA_in_trial(2001:end, :), grp(2001:end, :), 'VariableNames', {'DA', 'grp'});
    data = sortrows(data, 'grp');
    unq_grp = unique(data.grp);
    mu_DA = nan([numel(unq_grp), 9]);
    sigma_DA = nan([numel(unq_grp), 9]);
    for i = 1:size(mu_DA, 1)
        mu_DA(i, :) = mean(data.DA(data.grp == unq_grp(i), :));
        sigma_DA(i, :) = std(data.DA(data.grp == unq_grp(i), :));
    end
    mu_DA_alter = mean(data.DA(1:find(trial_on < teleport_on(1), 1, 'last')-2000, :));
    sigma_DA_alter = std(data.DA(1:find(trial_on < teleport_on(1), 1, 'last')-2000, :));

    figure;
    imagesc(data.DA);
    xlabel('Cue');
    ylabel('Trial');
    colorbar;
    title('Dopamine activity predicted by the ANCCR model');

    figure;
    errorbar(1:9, mu_DA_alter, sigma_DA_alter);
    hold on;
    errorbar(1:9, mu_DA(2, :), sigma_DA(2, :));
    errorbar(1:9, mu_DA(3, :), sigma_DA(3, :));
    errorbar(1:9, mu_DA(4, :), sigma_DA(4, :));
    hold off;
    xlabel('Cue');
    ylabel('Dopamine activity');
    legend({'Standard', 'Teleport 1', 'Teleport 2', 'Teleport 3'});
    title('Average dopamine activity predicted by the ANCCR model');

    figure;
    errorbar(1:9, mu_DA_alter, sigma_DA_alter, '-o');
    hold on;
    plot(1:9, data.DA(find(data.grp == 2, 1), :));
    plot(1:9, data.DA(find(data.grp == 4, 1), :));
    plot(1:9, data.DA(find(data.grp == 6, 1), :));
    hold off;
    xlabel('Cue');
    ylabel('Dopamine activity');
    legend({'Standard', 'Teleport 1', 'Teleport 2', 'Teleport 3'});
    title(sprintf('First teleport dopamine activity predicted by the ANCCR model\n(aligned by trial on)'));

    figure;
    errorbar(1:9, mu_DA_alter, sigma_DA_alter, '-o');
    hold on;
    plot(2:9, data.DA(find(data.grp == 2, 1), 1:8));
    plot(2:9, data.DA(find(data.grp == 4, 1), 1:8));
    plot(2:9, data.DA(find(data.grp == 6, 1), 1:8));
    hold off;
    xlabel('Cue');
    ylabel('Dopamine activity');
    legend({'Standard', 'Teleport 1', 'Teleport 2', 'Teleport 3'});
    title(sprintf('First teleport dopamine activity predicted by the ANCCR model\n(aligned by reward on)'));
end