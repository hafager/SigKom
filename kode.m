function kode()
    %telefon_nr = input('Vennligst skriv inn dit telefonnummer: ');
    telefon_nr = '48123012';
    lag_toner(telefon_nr);
    %spill_av(toner);
    
    
end

function lag_toner(tall)
    
    kolonner = [1209, 1336, 1477];
    rader = [697, 770, 852, 941];
    total = [];
    for i=1:4
        for s =1:3
            total = [ total [rader(i); kolonner(s)]];
        end
    end
    disp(total)
    
    Fs = 8000;
    tmin = 0;
    tmax = 0.2;
    dt = 1/Fs;
    t = tmin:dt:tmax;
    
    for i=1:8,
        disp(i)
        siffer = tall(i);
        if siffer == '#'
            siffer = '12';
        elseif siffer == '*'
            siffer = '10';
        elseif siffer == '0'
            siffer = '11';
        end
        x1 = cos(total(1,str2num(siffer))*2*pi*t);
        x2 = cos(total(2,str2num(siffer))*2*pi*t);
        y = x1+x2;
        sound(y, Fs);
        pause(0.7);
    end
    
    
end



