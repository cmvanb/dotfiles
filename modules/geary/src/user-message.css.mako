/*------------------------------------------------------------------------------
    Geary Custom CSS
------------------------------------------------------------------------------*/
html {
    color-scheme: dark !important;

    background-color: ${color_hash('gray_2')} !important;
    color: ${color_hash('system_text')} !important;
}

body, div, blockquote, table, td, th, p, span, pre,
h1, h2, h3, h4, h5, h6, li, ul, ol {
    color: ${color_hash('text_0')} !important;
}

/* Quoted reply blocks */
blockquote {
    border-left: 3px solid ${color_hash('gray_4')} !important;
    background-color: ${color_hash('gray_3')} !important;
    color: ${color_hash('text_15')} !important;
}

/* Proton/Gmail-style quote wrappers */
.protonmail_quote,
.gmail_quote,
.yahoo_quoted,
[class*="quote"],
[id*="quote"] {
    background-color: ${color_hash('gray_3')} !important;
    color: ${color_hash('text_15')} !important;
}

/* Quote show/hide toggle buttons */
.geary-quote-container {
    background-color: ${color_hash('gray_3')} !important;
    color: ${color_hash('text_15')} !important;
}

.geary-quote-container .geary-button {
    color: ${color_hash('text_12')} !important;
    background-image: none !important;
    background-color: ${color_hash('gray_4')} !important;
    border-color: ${color_hash('gray_6')} !important;
    border-bottom-color: ${color_hash('gray_6')} !important;
    text-shadow: none !important;
    box-shadow: none !important;
    outline-color: transparent !important;
}

.geary-quote-container .geary-button:hover {
    color: ${color_hash('text_12')} !important;
    background-image: none !important;
    background-color: ${color_hash('gray_5')} !important;
    border-color: ${color_hash('gray_6')} !important;
    border-bottom-color: ${color_hash('gray_6')} !important;
    text-shadow: none !important;
    box-shadow: none !important;
}

/* Override inline text color styles */
[style*="color"] {
    color: ${color_hash('text_0')} !important;
}
