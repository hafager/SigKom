



% HOVEDFUNKSJON

function main()
    telefon_nr = input('Vennligst skriv inn ditt telefonnummer: ', 's');    
    lag_og_spill_toner(telefon_nr);
    
end


function filteret = lagFiltre() %Funksjon som oppretter filteret
    filteret = []; %Oppretter en matrise til filteret
    frekvenser = [697 770 852 941 1209 1336 1477]; %Frekvensene til telefonen
    Fs = 8000; %Samplingsfrekvensen
    bredde = 300; %Bredden på filteret/Antall punkter
    n = 0:bredde-1; %Tallrekke fra 0 til bredde-1
    
    for i=1:length(frekvenser) %For-løkke som går gjennom alle frekvensene
        w0 = 2*pi*frekvenser(i)/Fs; %Vinkelfrekvens
        am = 2*cos(w0*n)/bredde; %Frekvenverdier til systemet/Signal vi ønsker å slippe gjennom BP-filteret
    
        filteret = [filteret; am]; %Legger frekvensverdier til i filteret
  
        %Plotter båndfiltrene!
        [h w] = freqz(am, 1, bredde); %Beregner frekvensresponsen
        d = w*Fs/(2*pi); % 
        plot(d, abs(h)); %Plotter BP-filterer
        axis ([0 2000 0 1]); %Setter aksene
        hold on %Legger alle plottene i samme figur
    end
end

function tallene = finn_tall(toner) %Funksjon som finner hvilke tall som er trykket utifra frekvensene
    Fs = 8000; %Samplingsfrekvens
    sum = 0; %Sum av frekvenser
    bredde = 300; %Bredden på filteret/Antall punkter
    frekvenser = [697 770 852 941 1209 1336 1477];%Frekvensene
    toneLengde = Fs*0.2; %Hvor lang hver tone er
    pauseLengde = Fs*0.05; %Hvor lang hver pause er
    antallTall = round(length(toner)/(toneLengde + pauseLengde)); %Finner antall tall som er trykker
    filter2 = lagFiltre(); %Henter filtrene fra lagFiltre() som filter2
    tallene = []; %Tom matrise som vi ende opp med tallene som er trykket
    
    for s=0:antallTall-1 %Går gjennom alle tallene som er trykket
        resultat = []; %Tom matrise som vil inneholde frekvensene som er gått gjennom filteret
        start = round((s*(toneLengde + pauseLengde)) + 1); %Når de ulike tonene starter
        slutt = round((s*(toneLengde + pauseLengde)) + toneLengde); %Når de ulike tonene slutter
        tone = toner(start:slutt); %Fjerner alt annet enn kun den aktuelle tonen
        for t=1:length(frekvenser) %Går gjennom alle frekvensene i filteret
            filter1 = filter(filter2(t,1:bredde),1,tone); %Kjører hver tone gjennom filteret og spytter ut hvor godt det passer
            if (max(filter1) > 0.75) %Passer tonen mer en 75%...
                resultat = [resultat t]; %...legges den til i resultatlisten
            end
        end
        frekvens1 = frekvenser(resultat(1)); %Hver tone består av 2 frekvenser, der de ligger i resultat(1) og resultat(2) 
        frekvens2 = frekvenser(resultat(2));
        sum = frekvens1 + frekvens2; %Summene av frekvensene brukes til å finne hvilke tall de stammer fra
        tallene = [tallene frekvensTilTall(sum)]; %Liste med hvilke tall som er trykket. Resultatet av frekvensTilTall legges inn
    end 
end      

% LAGER OG SPILLER AV TONENE
function toner = lag_og_spill_toner(tall)
    

    % Her lager vi en matrise der hver kolone tilsvarer frekvensparene som representerer tastetrykket 
    kolonner = [1209, 1336, 1477];
    rader = [697, 770, 852, 941];
    total = [];
    for i=1:4
        for s =1:3
            total = [ total [rader(i); kolonner(s)]];
            
        end
    end

    % Her lager vi variabelene vi skal bruke
    Fs = 8000;      % Samplingsfrekvens
    dt = 1/Fs;      % Perioden
    t = 0:dt:0.2;   % Matrise for tiden ved hver sampling
    stille = zeros(1,Fs*0.05);   % Pause mellom tonene. 8000*0.05 = 400
    toner = [];     % Oppretter matrise som vi skal legge alle tonene inn i

    for i= tall
        siffer = i;
        % Sjekker om det fins ugyldig input
        if siffer=='#'||siffer=='*'||siffer=='0'||siffer=='1'||siffer=='2'||siffer=='3'||siffer=='4'||siffer=='5'||siffer=='6'||siffer=='7'||siffer=='8'||siffer=='9'
            % Endrer verdien for 0, * og # for å få riktig indeks i 'total'
            if siffer == '#'
                siffer = '12';
            elseif siffer == '*'
                siffer = '10';
            elseif siffer == '0'
                siffer = '11';
            end
            
            % Genererer signalet, og legger det til i toner
            x1 = cos(total(1,str2num(siffer))*2*pi*t);
            x2 = cos(total(2,str2num(siffer))*2*pi*t);
            y = x1+x2;      % Legger sammen de to signalene
            toner = [toner y];
            toner = [toner stille];

        else
            % Hvis det finnes ugyldig input, kaller den programmet på nytt.
            disp('Det finnes en feil i nummeret du oppgav. Proev igjen.');
            toner = [];
            main()
            break

        end
        
    end
    % Spiller av tonene med riktig frekvens
    sound(toner, Fs);
    %Finner nummeret utifra lyden
    k=['Nummeret var: ' finn_tall(toner)]; %Finner og printer hvilke tall som er trykket utifra matrisen med toner. 
    disp(k);
end

function tall = frekvensTilTall(sum) %Funksjon som finner hvilken sum av 2 frekvenser som hører til hvilket tastetrykk
    switch(sum)
        case(697+1209)
            tall = '1';
        case(697+1336)
            tall = '2';
        case(697+1477)
            tall = '3';
        case(770+1209)
            tall = '4';
        case(770+1336)
            tall = '5';
        case(770+1477)
            tall = '6';
        case(852+1209)
            tall = '7';
        case(852+1336)
            tall = '8';
        case(852+1477)
            tall = '9';
        case(941+1209)
            tall = '*';
        case(941+1336)
            tall = '0';
        case(941+1477)
            tall = '#';
        otherwise %Hvis summen av frekvenser ikke passer med noen av de gitte frekvensene
            tall = 'FEIL!';
            
    end
            
end

