{pkgs, ...}: {
  home.packages = with pkgs; [
    (texlive.combine {
      inherit
        (texlive)
        scheme-basic
        latex-bin
        context
        pgf
        bibtex
        luatex
        xetex
        collection-langchinese
        ;
    })
  ];
}
