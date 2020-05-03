function value = numericSymbol(s, tsparam)
    try
        tsparam = sym(double(s));
        value = double(s);
    catch
        value = 0.0;
    end
    
end