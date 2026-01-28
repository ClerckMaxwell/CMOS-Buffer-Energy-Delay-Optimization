clc; clear; close all;

% --- Configurazione ---
filename = 'log_buffer_50x.log'; 
if ~exist(filename, 'file')
    error('File log non trovato!');
end

content = fileread(filename);

% --- Estrazione Dati Monte Carlo ---
energy = extract_ltspice_measure(content, 'energia');
fall   = extract_ltspice_measure(content, 'ritardo_fall');
rise   = extract_ltspice_measure(content, 'rise_time');

% --- Dati Validazione Spice (I tuoi 16 punti finali) ---
% Inseriamo i dati che hai appena postato
spice_delay = [ 1.62e-10, ...
               1.65e-10, 1.72e-10, 1.80e-10, 1.89e-10, 1.98e-10, 2.06e-10, 2.16e-10, ...
               2.25e-10, 2.34e-10];

energia_spice = [5.85e-14, ...
                 4.71e-14, 4.34e-14, 4.15e-14, 4.03e-14, 3.94e-14, 3.87e-14, 3.81e-14, ...
                 3.76e-14, 3.72e-14];

% --- Verifica e Plot ---
if isempty(energy) || isempty(fall) || isempty(rise)
    fprintf('\nATTENZIONE: Alcuni dati mancano nel file log.\n');
else
    delay_avg = (fall + rise) / 2;
    
% --- Plot Energy-Delay Space Aggiornato ---
figure('Color', 'w', 'Name', 'Pareto Frontier Analysis - High Visibility');

% 1. Plot della nuvola Monte Carlo
% Ho aumentato la dimensione dei punti a 20 e l'Alpha a 0.4.
% Ho usato un colore blu più saturo [0 0.447 0.741]
scatter(delay_avg * 1e12, energy * 1e15, 20, [0 0.447 0.741], 'filled', ...
    'MarkerFaceAlpha', 0.4, 'MarkerEdgeAlpha', 0); 
hold on;

% 2. Plot della Frontiera di Pareto (Validazione Spice)
% La linea è nera o rossa molto spessa per contrastare con la nuvola
plot(spice_delay * 1e12, energia_spice * 1e15, 'LineWidth', 3, ...
    'MarkerSize', 8, 'MarkerFaceColor', 'r');

% --- Estetica del Grafico ---
grid on;
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.3;
set(gca, 'FontSize', 12);

xlabel('Delay [ps]', 'FontWeight', 'bold');
ylabel('Energy [fJ]', 'FontWeight', 'bold');
title('Energy-Delay Design Space (10k Monte Carlo)', 'FontSize', 14);

legend('Design Space (Monte Carlo)', 'Frontiera di Pareto Validata', ...
    'Location', 'northeast');

% Imposta i limiti in modo che la nuvola non sia "schiacciata" sui bordi
margin_x = (max(delay_avg) - min(delay_avg)) * 0.05 * 1e12;
xlim([(min(delay_avg)*1e12 - margin_x), (max(delay_avg)*1e12 + margin_x)]);
end

% --- Funzione di estrazione (rimane la stessa) ---
function data = extract_ltspice_measure(content, name)
    pattern = ['Measurement: ' name '\s*\n.*?\n(.*?)(?:\r?\n\s*\r?\n|Measurement:|\z)'];
    block = regexp(content, pattern, 'tokens', 'once');
    if isempty(block), data = []; return; end
    clean_block = strtrim(block{1});
    rows = strsplit(clean_block, {'\n', '\r'});
    rows = rows(~cellfun(@isempty, rows));
    data = zeros(length(rows), 1);
    for i = 1:length(rows)
        parts = strsplit(strtrim(rows{i}));
        if length(parts) >= 2, data(i) = str2double(parts{2}); end
    end
end