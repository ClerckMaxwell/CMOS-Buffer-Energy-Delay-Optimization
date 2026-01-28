% clc; clear; close all;

% --- Configurazione ---
filename = 'log_buffer_50x.log'; % Assicurati che il file sia nella cartella di MATLAB
if ~exist(filename, 'file')
    error('File log non trovato!');
end

% Leggi tutto il file
content = fileread(filename);

% --- Estrazione Dati ---
% Estrazione effettiva (Chiamate alle funzioni spostate qui sopra)
energy = extract_ltspice_measure(content, 'energia');
fall   = extract_ltspice_measure(content, 'ritardo_fall');
rise   = extract_ltspice_measure(content, 'rise_time');

% --- Verifica e Plot ---
if isempty(energy) || isempty(fall) || isempty(rise)
    fprintf('\nATTENZIONE: Alcuni dati mancano nel file log.\n');
    fprintf('Nel file caricato, la misura "energia" è fallita.\n');
else
    % Calcolo Delay Medio
    delay_avg = (fall + rise) / 2;
    
    % Plot Energy-Delay Space
    figure('Color', 'w', 'Name', 'Pareto Frontier Analysis');
    scatter(delay_avg * 1e12, energy * 1e15, 15, 'filled', 'MarkerFaceAlpha', 0.2);
    
    hold on;
    grid on;
    xlabel('Delay [ps]');
    ylabel('Energy [fJ]');
    title('Energy-Delay Design Space (10k Monte Carlo)');
end
function data = extract_ltspice_measure(content, name)
    % Improved pattern: 
    % 1. Finds 'Measurement: name'
    % 2. Skips the header line (step, INTEG, etc.)
    % 3. Captures everything until a double newline or the next Measurement
    pattern = ['Measurement: ' name '\s*\n.*?\n(.*?)(?:\r?\n\s*\r?\n|Measurement:|\z)'];
    
    block = regexp(content, pattern, 'tokens', 'once');
    
    if isempty(block)
        warning('Misura "%s" non trovata!', name);
        data = [];
        return;
    end

    % Clean the block and split into rows
    clean_block = strtrim(block{1});
    rows = strsplit(clean_block, {'\n', '\r'});
    rows = rows(~cellfun(@isempty, rows)); % Remove empty rows
    
    data = zeros(length(rows), 1);
    for i = 1:length(rows)
        parts = strsplit(strtrim(rows{i}));
        if length(parts) >= 2
            % Index 2 is the value (e.g., 4.29297e-14)
            data(i) = str2double(parts{2});
        end
    end
end